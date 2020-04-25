//
//  UserProfileView.swift
//  PunchTasks
//
//  Created by deryzhou on 2020/4/25.
//  Copyright © 2020 Zzz(Test). All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    var user: UserInfo

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: PunchTask.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PunchTask.title, ascending: true)],
        predicate: NSPredicate(format: "%K == %d", #keyPath(PunchTask.isComplete), true)
    ) var fetchedItems: FetchedResults<PunchTask>

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 2) {
                Text("共计打卡 \(user.totalPunchs) 次，孵化 \(user.sucPunchs) 个蛋")
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                Divider()
                
                List {
                    ForEach(fetchedItems, id: \.self){ item in
                        PunchTaskView(task: item)
                    }
                }
                .navigationBarTitle(Text(user.name!))
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let testUser = UserInfo(context: context)
        testUser.name = "<Test>"
        testUser.isGirl = true
        testUser.totalPunchs = 999
        testUser.sucPunchs = 99

        return UserProfileView(user: testUser).environment(\.managedObjectContext, context)
    }
}
