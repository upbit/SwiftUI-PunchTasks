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
        sortDescriptors: [NSSortDescriptor(keyPath: \PunchTask.update, ascending: false)],
        predicate: NSPredicate(format: "%K == %d", #keyPath(PunchTask.isComplete), true)
    ) var fetchedItems: FetchedResults<PunchTask>
    @FetchRequest(
        entity: UserInfo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.totalPunchs, ascending: true)]
    ) var userInfoItems: FetchedResults<UserInfo>

    @State var showModalView: Bool = false
    @State var selectedMonster: PunchTask? = nil

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 2) {
                Text("共计打卡 \(user.totalPunchs) 次，孵化 \(user.sucPunchs) 个蛋")
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                Divider()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        ForEach(fetchedItems, id: \.self) { item in

                            VStack {
                                Image(item.monsterImage!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 88, height: 96)
                                    .shadow(radius: 8.0)
                                Text(item.title!)
                                    .font(.subheadline)
                                    .foregroundColor(.UKON)
                                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                            }
                            .onTapGesture {
                                self.showModalView = true
                                self.selectedMonster = item
                            }
                            .padding(.leading, 12)

                        }
                    }
                }
                .frame(height: 192)
                .sheet(isPresented: $showModalView) {
                    CompleteTaskView(user: self.userInfoItems.first!, task: self.selectedMonster!, showModal: self.$showModalView)
                }

                Spacer()
            }
            .navigationBarTitle(user.name!)
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
