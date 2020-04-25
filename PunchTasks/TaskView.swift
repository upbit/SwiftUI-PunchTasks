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
    @FetchRequest(
        entity: UserInfo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.totalPunchs, ascending: true)]
    ) var userInfoItems: FetchedResults<UserInfo>
    
    var body: some View {
        return VStack {
            if task.isComplete == false {
                InCompleteTaskView(user: userInfoItems.first!, task: task)
            } else {
                CompleteTaskView(user: userInfoItems.first!, task: task, showModal: .constant(false))
            }
        }
    }
    
}

#if DEBUG
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
#endif
