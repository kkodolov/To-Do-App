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
    }
    
    private func loadTasks() {
        selectedType.forEach { type in
            tasks[type] = []
        }
        
        taskStorage.load().forEach { task in
            guard var _ = tasks[task.type] else { return }
            tasks[task.type]!.append(task)
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
