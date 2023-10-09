//
//  TaskDAO.swift
//  watchos-todoapp Watch App
//
//  Created by Bryan on 08/10/23.
//

import Foundation
import SQLite

class TaskDAO {
    let dbManager: DatabaseManager
    private let tasks = Table("tasks")
    private let id = Expression<Int>("id")
    private let title = Expression<String>("title")
    
    init(dbManager: DatabaseManager) {
        self.dbManager = dbManager
    }
    
    func addTask(taskName: String) {
        let insertTask = tasks.insert(title <- taskName)
        do {
            try dbManager.db?.run(insertTask)
        } catch {
            print("Error inserting task: \(error)")
        }
    }
    
    func deleteTask(taskID: Int) {
        let taskToDelete = tasks.filter(self.id == taskID)
        do {
            try dbManager.db?.run(taskToDelete.delete())
        } catch {
            print("Error deleting task: \(error)")
        }
    }
    
    func getAllTasks() -> [Task] {
        var tasksArray: [Task] = []
        do {
            for task in try dbManager.db!.prepare(tasks) {
                let t = Task(id: task[id], title: task[self.title])
                tasksArray.append(t)
            }
        } catch {
            print("Error fetching tasks: \(error)")
        }
        return tasksArray
    }
}
