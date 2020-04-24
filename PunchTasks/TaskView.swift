//
//  TaskView.swift
//  PunchTasks
//
//  Created by deryzhou on 2020/4/18.
//  Copyright © 2020 Zzz(Test). All rights reserved.
//

import SwiftUI

struct TaskView: View {
    var task: PunchTask

    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        return VStack {
            Spacer()
            
            if task.isComplete == false {
                InCompleteTask(task: task)
            } else {
                CompleteTask(task: task)
            }
            
            Spacer()
        }
        .padding(.horizontal, 100)
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 129.0/255.0, green: 199.0/255.0, blue: 212.0/255.0),
                Color(red: 248.0/255.0, green: 195.0/255.0, blue: 205.0/255.0),
            ]), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all))
    }
    
}

struct InCompleteTask: View {
    var task: PunchTask
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var selected: Bool = false
    
    var body: some View {
        let progress = CGFloat(Double(task.count) / Double(task.countMax))
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: 100 - 10, y: 125)
        animation.toValue = CGPoint(x: 100 + 10, y: 125)
        
        return VStack {

            Text(task.title!)
                .font(.headline)
                .foregroundColor(
                    Color(red: 239.0/255.0, green: 187.0/255.0, blue: 36.0/255.0)
                )
                .shadow(radius: 4.0, x: 2.0, y: 2.0)

            Image(task.eggImage!)
                .shadow(radius: 8.0, x: 4.0, y: 2.0)
                .modifier(eggShakeEffect(shakes: selected ? 2 : 0))
                .animation(Animation.linear)
                .onTapGesture {
                    self.selected.toggle()
                }

            ProgressBar(size: 200.0, progress: progress)

            Text(String(format: "加油！再打卡 %d 天就能孵化了", task.countMax-task.count))
                .font(.subheadline)
                .frame(minWidth: 240.0)
                .foregroundColor(.gray)
                .padding(.bottom, 32)

            Button(action: {
                withAnimation {
                    if self.punchTask(task: self.task) {
                        self.selected.toggle()
                    }
                }
                
            }) {
                Text("打卡")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 48)
                    .background(
                        Color(red: 247.0/255.0, green: 217.0/255.0, blue: 76.0/255.0)
                    )
                    .cornerRadius(24.0)
                    .shadow(radius: 8.0, x: 4, y: 10)
            }
            
        }
    }
    
    func punchTask(task: PunchTask) -> Bool {
        let now = Date()
        let sameDay = now.isSameDay(toDate: task.update!)
        if (task.count == 0) || (task.count < task.countMax && !sameDay) {
            task.count += 1
            task.update = now
            
            if task.count == task.countMax {
                task.isComplete = true
            }
            
            do {
                try managedObjectContext.save()
                return true
            } catch {
                print(error.localizedDescription)
            }
        }
    
        return false
    }
}

struct eggShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        let ani = CGAffineTransform(translationX: size.width/2, y: 3*size.height/4)
            .rotated(by: -0.1 * sin(position * 2 * .pi))
            .translatedBy(x: -size.width/2, y: -3*size.height/4)
        return ProjectionTransform(ani)
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

struct CompleteTask: View {
    var task: PunchTask
    
    @State var scale: CGFloat = 0.8
    
    var body: some View {
        return VStack {
            
            if task.monsterImage! == "poke_pikaqu" {
                Image(task.monsterImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 192, height: 248)
                    .shadow(radius: 8.0, x: 4.0, y: 2.0)
                    .padding(.bottom, 24)
                    .padding(.trailing, 48)
                    .scaleEffect(scale)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 0.5)
                        let repeated = baseAnimation.repeatCount(3, autoreverses: true)
                        return withAnimation(repeated) {
                            self.scale = 1.0
                        }
                    }
            } else {
                Image(task.monsterImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 192, height: 248)
                    .shadow(radius: 8.0, x: 4.0, y: 2.0)
                    .padding(.leading, 16)
                    .scaleEffect(scale)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 0.5)
                        let repeated = baseAnimation.repeatCount(3, autoreverses: true)
                        return withAnimation(repeated) {
                            self.scale = 1.0
                        }
                    }
            }

            Text(task.title!)
                .font(.headline)
                .foregroundColor(
                    Color(red: 239.0/255.0, green: 187.0/255.0, blue: 36.0/255.0)
                )
                .shadow(radius: 4.0, x: 2.0, y: 2.0)
                .padding(.top, 16)
            
            Text(String(format: "恭喜你坚持了 %d 天", task.count))
                .font(.subheadline)
                .foregroundColor(.gray)
                .shadow(radius: 4.0, x: 2.0, y: 2.0)
                .padding(.top, 8)

        }
    }
}

struct ProgressBar: View {
    var size: CGFloat = 200.0
    var progress: CGFloat = 0.0
    
    var body: some View {
        return ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color.gray)
                .opacity(0.3)
                .frame(width: size, height: 8.0)
            Rectangle()
                .foregroundColor(Color.green)
                .frame(width: size * progress, height: 8.0)
        }
        .cornerRadius(8.0)
    }
}

extension Date {
    func hoursBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: toDate, to: self)
        return components.hour ?? 0
    }

    func isSameDay(toDate: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: self) == formatter.string(from: toDate)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let testTask = PunchTask(context: context)
        testTask.title = "Test"
        testTask.initRandomMonster()
        // testTask.isComplete = true
        
        return TaskView(task: testTask).environment(\.managedObjectContext, context)
    }
}
