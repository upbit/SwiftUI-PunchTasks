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
                .foregroundColor(.UKON)
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
        
        return CompleteTaskView(user: testUser, task: testTask).environment(\.managedObjectContext, context)
    }
}
#endif
