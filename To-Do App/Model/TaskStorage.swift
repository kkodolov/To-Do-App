//
//  TaskStorage.swift
//  To-Do App
//
//  Created by Костя Кодолов on 13.12.2025.
//

import Foundation

protocol TaskStorageProtocol {
    func save(tasks: [TaskProtocol])
    func load() -> [TaskProtocol]
}

class TaskStorage: TaskStorageProtocol {
    
    private var storage = UserDefaults.standard
    private var storageKey = "tasks"
    
    private enum TaskKey: String {
        case title
        case type
        case status
    }
    
    func save(tasks: [any TaskProtocol]) {
        var arrayForStorage: [[String: String]] = []
        tasks.forEach { task in
            var newElementForStorage: [String: String] = [:]
            newElementForStorage[TaskKey.title.rawValue] = task.title
            newElementForStorage[TaskKey.type.rawValue] = task.type == .important ? "Important" : "Normal"
            newElementForStorage[TaskKey.status.rawValue] = task.status == .planned ? "Planned" : "Completed"
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
    
    func load() -> [any TaskProtocol] {
        let tasksFromStorage = storage.array(forKey: storageKey) as? [[String: String]] ?? []
        var storage: [TaskProtocol] = []
        for task in tasksFromStorage {
            guard let title = task[TaskKey.title.rawValue],
                  let type: TaskType = task[TaskKey.type.rawValue] == "Important" ? .important : .normal,
                  let status: TaskStatus = task[TaskKey.status.rawValue] == "Planned" ? .planned : .completed else { continue }
            
            let taskForStorage = Task(title: title, type: type, status: status)
            storage.append(taskForStorage)
        }
        return storage
    }
}
