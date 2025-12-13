//
//  TaskListController.swift
//  To-Do App
//
//  Created by Костя Кодолов on 13.12.2025.
//

import UIKit

class TaskListController: UITableViewController {
    
    var taskStorage: TaskStorageProtocol = TaskStorage()
    var tasks: [TaskType: [TaskProtocol]] = [:]
    var selectedType: [TaskType] = [.important, .normal]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
        
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    private func loadTasks() {
        selectedType.forEach { type in
            tasks[type] = []
        }
        
        taskStorage.load().forEach { task in
            guard var _ = tasks[task.type] else { return }
            tasks[task.type]!.append(task)
        }

        sortTasks()
    }
    
    private func sortTasks() {
        for (taskType, task) in tasks {
            tasks[taskType] = task.sorted(by: { $0.status.rawValue < $1.status.rawValue })
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let type = selectedType[section]
        title = (type == .important) ? "Important" : "Normal"
        return title
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = selectedType[section]
        return tasks[type]?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getConfiguredCell(by: indexPath)
    }
    
    private func getConfiguredCell(by indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        let type = selectedType[indexPath.section]
        
        guard let task = tasks[type]?[indexPath.row] else { return cell }
        
        if task.status == .completed {
            cell.symbol.text = "\u{25C9}"
        } else {
            cell.symbol.text = "\u{25CB}"
        }
        cell.title.text = task.title
        
        if task.status == .completed {
            cell.symbol.textColor = .tertiaryLabel
            cell.title.textColor = .tertiaryLabel
        } else {
            cell.symbol.textColor = .label
            cell.title.textColor = .label
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let type = selectedType[indexPath.section]
        tasks[type]?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let typeFrom = selectedType[fromIndexPath.section]
        let typeTo = selectedType[to.section]
        
        guard let movedItem = tasks[typeFrom]?[fromIndexPath.row] else { return }
        
        tasks[typeFrom]!.remove(at: fromIndexPath.row)
        tasks[typeTo]!.insert(movedItem, at: to.row)
        
        if typeFrom != typeTo {
            tasks[typeTo]![to.row].type = typeTo
        }
        
        sortTasks()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
