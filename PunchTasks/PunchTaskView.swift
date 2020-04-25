//
//  PunchTaskView.swift
//  PunchTasks
//
//  Created by deryzhou on 2020/4/25.
//  Copyright © 2020 Zzz(Test). All rights reserved.
//

import SwiftUI

struct PunchTaskView: View {
    var task: PunchTask
    
    var body: some View {
        return HStack {
            
            if task.isComplete == false {
                Image(task.eggImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 48)
                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                    .padding(.leading, 16)
                Text(task.title!)
                    .font(.headline)
                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                    .padding(.leading, 16)
            } else {
                Image(task.monsterImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 48)
                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                    .padding(.leading, 16)
                Text(task.title!)
                    .font(.headline)
                    .foregroundColor(.KOHAKU)
                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                    .padding(.leading, 16)
            }
            
            Spacer()
            
            if task.isComplete == false {
                Text("\(task.count) / \(task.countMax)")
                    .font(.custom("Helvetica Neue", size: 14))
                    .foregroundColor(.gray)
                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                    .padding(.trailing, 8)
            } else {
                Text("已孵化")
                    .font(.custom("Helvetica Neue", size: 14))
                    .foregroundColor(.KOHAKU)
                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                    .padding(.trailing, 8)
            }

        }
    }
}

#if DEBUG
struct PunchTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let testTask = PunchTask(context: context)
        testTask.title = "Test"
        testTask.update = Date()
        testTask.initRandomMonster()
        testTask.isComplete = false
        
        return PunchTaskView(task: testTask).environment(\.managedObjectContext, context)
    }
}
#endif
