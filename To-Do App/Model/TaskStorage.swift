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
    
    func save(tasks: [any TaskProtocol]) {}
    
    func load() -> [any TaskProtocol] {
        let tasksFromStorage: [TaskProtocol] = [
            Task(title: "Купить молоко", type: .normal, status: .planned),
            Task(title: "Забрать дочь из садика", type: .important, status: .planned),
            Task(title: "Заправить машину", type: .important, status: .completed),
            Task(title: "Сделать дома уборку", type: .normal, status: .completed),
            Task(title: "Записаться к доктору", type: .important, status: .planned),
            Task(title: "Освоить програмирование", type: .important, status: .planned)
        ]
        return tasksFromStorage
    }
}
