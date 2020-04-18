//
//  TaskView.swift
//  PunchTasks
//
//  Created by deryzhou on 2020/4/18.
//  Copyright © 2020 Zzz(Test). All rights reserved.
//

import SwiftUI

struct TaskView: View {
    var index: Int = 0

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: PunchTask.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PunchTask.update, ascending: false)]
    ) var fetchedItems: FetchedResults<PunchTask>
    
    var body: some View {
        let task = fetchedItems[index]
        let days = task.countMax - task.count
        let progress = CGFloat(Double(task.count) / Double(task.countMax))
        
        return VStack {
            Spacer()

            Text(task.title ?? "Empty")
                .font(.headline)
                .shadow(radius: 4.0, x: 2.0, y: 2.0)
            Image(task.eggImage!)
                .shadow(radius: 8.0, x: 4.0, y: 2.0)

            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray)
                    .opacity(0.3)
                    .frame(width: 200.0, height: 8.0)
                Rectangle()
                    .foregroundColor(Color.green)
                    .frame(width: 200.0 * progress, height: 8.0)
            }
            .cornerRadius(8.0)
            Text("加油！再打卡 \(days) 天就能孵化了")
                .font(.subheadline)
                .frame(minWidth: 240.0)
                .foregroundColor(.gray)
                .padding(.bottom, 32)

            Button(action: {
                self.punchTask(task: task)
            }) {
                Text("打卡")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 48)
                    .background(
                        Color(red: 247.0/255.0, green: 217.0/255.0, blue: 76.0/255.0)
                    )
                    .cornerRadius(24.0)
                    .shadow(radius: 8.0, x: 4, y: 10)
            }
            Spacer()
        }
        .padding(.horizontal, 100)
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 129.0/255.0, green: 199.0/255.0, blue: 212.0/255.0),
                Color(red: 248.0/255.0, green: 195.0/255.0, blue: 205.0/255.0),
            ]), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all))
    }
    
    func punchTask(task: PunchTask) {
        if task.count < task.countMax {
            task.count += 1
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        return TaskView(index: 0).environment(\.managedObjectContext, context)
    }
}
