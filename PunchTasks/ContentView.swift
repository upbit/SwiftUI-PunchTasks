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
        sortDescriptors: [NSSortDescriptor(keyPath: \PunchTask.update, ascending: false)]
    ) var fetchedItems: FetchedResults<PunchTask>
    // predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: false)

    @State private var newTaskTitle: String = ""

    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    TextField("新增打卡目标...", text: $newTaskTitle)
                        .padding(.leading, 16)
                    Button(action: {
                        self.addTask()
                    }) {
                       Image(systemName: "plus")
                    }
                    .padding(.all, 16)
                }
                .background(
                    Color(red: 235.0/255.0, green: 245.0/255.0, blue: 255.0/255.0)
                )

                List {
                    ForEach(fetchedItems, id: \.self){ item in
                        NavigationLink(destination:
                            TaskView(index: self.fetchedItems.firstIndex(of: item)!)
                        ) {
                            HStack {
                                Image(item.eggImage!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 36, height: 48)
                                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                                    .padding(.leading, 16)
                                
                                Text(item.title ?? "<empty>")
                                    .font(.headline)
                                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                                    .padding(.leading, 8)
                                
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                .navigationBarTitle("小雯雯", displayMode: .inline)
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

    func addTask() {
        guard newTaskTitle != "" else {
            return
        }

        let newTask = PunchTask(context: managedObjectContext)
        newTask.title = newTaskTitle
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

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ContentView().environment(\.managedObjectContext, context)
    }
}
