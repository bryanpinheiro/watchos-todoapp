//
//  TodoView.swift
//  watchos-todoapp Watch App
//
//  Created by Bryan on 08/10/23.
//

import SwiftUI

struct TodoView: View {
    @State private var tasks: [Task] = []
    @State private var taskTitle: String = ""
    private var taskDao = TaskDAO(dbManager: DatabaseManager())
    
    var body: some View {
        VStack {
            HStack {
                 TextField("Enter a task", text: $taskTitle)
                     .frame(maxWidth: .infinity, alignment: .leading)
                     .padding(.trailing, 4)
                 
                 Button(action: {
                     addTask()
                 }) {
                     Image(systemName: "plus").imageScale(.large)
                 }
                 .background(Color.blue)
                 .cornerRadius(24)
                 .frame(width: 48, height: 48)
                 .padding(.trailing, 6)
             }
             .padding()
            
            ScrollView {
                ForEach(tasks, id: \.id) { task in
                    VStack(spacing: 10) {
                        HStack {
                            Text(task.title)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            Button(action: {
                                deleteTask(id: task.id!)
                            }) {
                                Image(systemName: "trash")
                            }
                            .foregroundColor(.red).imageScale(.medium)
                            .cornerRadius(24)
                            .frame(width: 48, height: 48)
                            .padding(.leading, 20)
                        }
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                }
            }
            .padding(.top, 16)
        }
        .onAppear {
            fetchTasks()
        }
    }
    
    private func addTask() {
        if (!taskTitle.isEmpty) {
            taskDao.addTask(taskName: taskTitle)
            taskTitle = ""
            fetchTasks()
        }
    }
    
    private func fetchTasks() {
        tasks = taskDao.getAllTasks()
    }
    
    private func deleteTask(id: Int) {
        taskDao.deleteTask(taskID: id)
        fetchTasks()
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
