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
        sortDescriptors: [NSSortDescriptor(keyPath: \PunchTask.title, ascending: true)]
    ) var fetchedItems: FetchedResults<PunchTask>
    @FetchRequest(
        entity: UserInfo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.name, ascending: true)]
    ) var userInfoItems: FetchedResults<UserInfo>

    @State private var newTaskTitle: String = ""

    var body: some View {
        VStack {
            if userInfoItems.count == 0 {
                LoginView()
            } else {
                NavigationView {
                    VStack {
                        InputNewTask
                        Divider()
                        
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
                    .navigationBarTitle(Text(userInfoItems.first!.name!), displayMode: .inline)
                    .navigationBarItems(trailing:
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .imageScale(.large)
                            }
                        }
                    )
                }
            }
        }
    }

    private var InputNewTask: some View {
        return HStack {
            TextField("新增打卡目标...", text: $newTaskTitle)
                .padding([.leading, .top], 12)
            
            Button(action: {
                self.addTask()
            }) {
               Image(systemName: "plus")
            }.padding([.trailing, .top], 12)
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
                    .foregroundColor(
                        Color(red: 239.0/255.0, green: 187.0/255.0, blue: 36.0/255.0)
                    )
                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                    .padding(.leading, 16)
                
            }

            Spacer()
            
            if task.isComplete == false {
                Text(String(format: "%.0f%%", Double(task.count)/Double(task.countMax) * 100.0))
                    .font(.custom("Helvetica Neue", size: 14))
                    .foregroundColor(.gray)
                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
            } else {
                Text("已孵化")
                    .font(.custom("Helvetica Neue", size: 14))
                    .foregroundColor(.gray)
                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ContentView().environment(\.managedObjectContext, context)
    }
}
