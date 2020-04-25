//
//  ContentView.swift
//  PunchTasks
//
//  Created by deryzhou on 2020/4/18.
//  Copyright © 2020 Zzz(Test). All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: PunchTask.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PunchTask.title, ascending: true)],
        predicate: NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "%K == %d", #keyPath(PunchTask.isComplete), false),
            NSPredicate(format: "%K > %@", #keyPath(PunchTask.update), Date(timeIntervalSinceNow: -12 * 3600) as NSDate),
        ])
    ) var fetchedItems: FetchedResults<PunchTask>
    @FetchRequest(
        entity: UserInfo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.totalPunchs, ascending: true)]
    ) var userInfoItems: FetchedResults<UserInfo>

    @State private var newTaskTitle: String = ""

    var body: some View {
        VStack {
            if userInfoItems.count == 0 {
                LoginView()
            } else {
                NavigationView {
                    VStack(alignment: .leading, spacing: 2) {
                        InputNewTask
                            .padding([.leading, .top], 12)

                        Divider()
                            .padding(.top, 8)

                        List {
                            ForEach(fetchedItems, id: \.self){ item in
                                NavigationLink(destination:
                                    TaskView(task: item)
                                ) {
                                    PunchTaskView(task: item)
                                }
                            }.onDelete(perform: removeItems)
                        }
                    }
                    .navigationBarTitle("打卡小怪", displayMode: .inline)
                }
            }
        }
    }

    private var InputNewTask: some View {
        return HStack {
            TextField("新增打卡目标...", text: $newTaskTitle)
            
            Button(action: {
                self.addTask()
            }) {
               Image(systemName: "plus")
            }
            
            NavigationLink(destination:
                UserProfileView(user: userInfoItems.first!)
            ) {
                Image(systemName: "person.crop.circle")
                    .imageScale(.large)
            }
            .padding([.leading, .trailing], 8)
        }
    }
    
    func addTask() {
        guard newTaskTitle != "" else {
            return
        }

        let newTask = PunchTask(context: managedObjectContext)
        newTask.title = newTaskTitle
        newTask.update = Date()
        newTask.initRandomMonster()
        
        do {
            try managedObjectContext.save()
            self.newTaskTitle = ""
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeItems(at offsets: IndexSet) {
       for index in offsets {
            let item = fetchedItems[index]
            managedObjectContext.delete(item)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ContentView().environment(\.managedObjectContext, context)
    }
}
#endif
