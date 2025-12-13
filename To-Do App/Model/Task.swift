//
//  Task.swift
//  To-Do App
//
//  Created by Костя Кодолов on 13.12.2025.
//

import Foundation

protocol TaskProtocol {
    var title: String { get set }
    var type: TaskType { get set }
    var status: TaskStatus { get set }
}

enum TaskType {
    case important
    case normal
}

enum TaskStatus: Int {
    case planned
    case completed
}

struct Task: TaskProtocol {
    var title: String
    var type: TaskType
    var status: TaskStatus
}
