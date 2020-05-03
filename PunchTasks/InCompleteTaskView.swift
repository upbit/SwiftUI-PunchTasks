//
//  InCompleteTaskView.swift
//  PunchTasks
//
//  Created by deryzhou on 2020/4/25.
//  Copyright © 2020 Zzz(Test). All rights reserved.
//

import SwiftUI

struct InCompleteTaskView: View {
    var user: UserInfo
    var task: PunchTask
    
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var selected: Bool = false
    
    var body: some View {
        let progress = CGFloat(Double(task.count) / Double(task.countMax))

        return VStack {
            Spacer()
            
            Text(task.title!)
                .font(.headline)
                .foregroundColor(.UKON)
                .shadow(radius: 4.0, x: 2.0, y: 4.0)

            Image(task.eggImage!)
                .shadow(radius: 8.0, x: 2.0, y: 8.0)
                .modifier(eggShakeEffect(shakes: selected ? 2 : 0,
                                         ratio: Float(task.count)/Float(task.countMax)))
                .animation(Animation.linear(duration: 0.5))
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
                    .background(Color.NANOHANA)
                    .cornerRadius(24.0)
                    .shadow(radius: 8.0)
            }
            
            Spacer()
        }
        .padding(.horizontal, 100)
        .background(
            LinearGradient(gradient: Gradient(colors:
                user.isGirl ? [Color.MOMO, Color.MOMO, Color.MIZU] : [Color.MIZU, Color.MIZU, Color.MOMO]
            ), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all))
    }

    func punchTask(task: PunchTask) -> Bool {
        let now = Date()
        let sameDay = now.isSameDay(toDate: task.update!)
        // if (task.count == 0) || (task.count < task.countMax && !sameDay) {
        if true {
            task.count += 1
            user.totalPunchs += 1
            task.update = now

            if task.count == task.countMax {
                task.isComplete = true
                user.sucPunchs += 1
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

extension Date {
    func isSameDay(toDate: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: self) == formatter.string(from: toDate)
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

struct eggShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        let ani = CGAffineTransform(translationX: size.width/2, y: 3*size.height/4)
            .rotated(by: -angle * sin(position * 2 * .pi))
            .translatedBy(x: -size.width/2, y: -3*size.height/4)
        return ProjectionTransform(ani)
    }
    
    init(shakes: Int, ratio: Float) {
        position = CGFloat(shakes)
        angle = CGFloat(0.01 + 0.1 * ratio)
    }
    
    var position: CGFloat
    var angle: CGFloat
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(position, angle) }
        set {
            position = newValue.first
            angle = newValue.second
        }
    }
}

#if DEBUG
struct InCompleteTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let testUser = UserInfo(context: context)        
        let testTask = PunchTask(context: context)
        testTask.title = "Test"
        testTask.initRandomMonster()
        // testTask.isComplete = true
        
        return InCompleteTaskView(user: testUser, task: testTask).environment(\.managedObjectContext, context)
    }
}
#endif
