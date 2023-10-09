//
//  DatabaseManager.swift
//  watchos-todoapp Watch App
//
//  Created by Bryan on 08/10/23.
//

import Foundation
import SQLite

class DatabaseManager {
    var db: Connection?
    private let tasks = Table("tasks")
    private let id = Expression<Int>("id")
    private let title = Expression<String>("title")
    
    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            db = try Connection("\(path)/tasks.sqlite3")
            createTableIfNeeded()
        } catch {
            print("Error initializing database: \(error)")
        }
    }
    
    private func createTableIfNeeded() {
        do {
            try db?.run(tasks.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(title)
            })
        } catch {
            print("Error creating table: \(error)")
        }
    }
    
}
