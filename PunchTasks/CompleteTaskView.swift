//
//  CompleteTaskView.swift
//  PunchTasks
//
//  Created by deryzhou on 2020/4/25.
//  Copyright © 2020 Zzz(Test). All rights reserved.
//

import SwiftUI

struct CompleteTaskView: View {
    var user: UserInfo
    var task: PunchTask

    @Binding var showModal: Bool
    
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        return VStack {
            Spacer()
            
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
                .foregroundColor(.NANOHANA)
                .shadow(radius: 4.0, x: 2.0, y: 2.0)
                .padding(.top, 16)
            
            Text(String(format: "恭喜你坚持了 %d 天", task.count))
                .font(.subheadline)
                .foregroundColor(.gray)
                .shadow(radius: 4.0, x: 2.0, y: 2.0)
                .padding(.top, 8)

            if self.showModal {
                Button(action: {
                    self.showModal.toggle()
                }) {
                    Text("确认")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 48)
                        .background(Color.UKON)
                        .cornerRadius(24.0)
                        .shadow(radius: 8.0)
                }
                .padding(.top, 48)
            }

            Spacer()
        }
        .padding(.horizontal, 120)
        .background(
            LinearGradient(gradient: Gradient(colors:
                user.isGirl ? [Color.KOHAKU, Color.NANOHANA] : [Color.NANOHANA, Color.NANOHANA, Color.KOHAKU]
            ), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all))
    }
}

#if DEBUG
struct CompleteTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let testUser = UserInfo(context: context)
        let testTask = PunchTask(context: context)
        testTask.title = "Test"
        testTask.initRandomMonster()
        testTask.count = 99
        testTask.isComplete = true
        
        return CompleteTaskView(user: testUser, task: testTask, showModal:  .constant(true)).environment(\.managedObjectContext, context)
    }
}
#endif
