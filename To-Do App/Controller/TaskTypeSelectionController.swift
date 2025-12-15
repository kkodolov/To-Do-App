//
//  TaskTypeSelectionController.swift
//  To-Do App
//
//  Created by Костя Кодолов on 15.12.2025.
//

import UIKit

class TaskTypeSelectionController: UITableViewController {
    
    typealias TaskTypeDescription = (title: String, type: TaskType, description: String)
    
    var selectedType: TaskType = .normal
    var doAfterSelection: ((TaskType) -> Void)?
    
    private var listOfTypes: [TaskTypeDescription] = [
        (title: "Important", type: .important, description: "Such type of task is more important for completing. All important tasks are on top of task's list"),
        (title: "Normal", type: .normal, description: "Task with common priority")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 80
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeSelectionCell", for: indexPath) as! TypeCell
        let type = listOfTypes[indexPath.row]
        
        cell.typeTitle.text = type.title
        cell.typeDescription.text = type.description
        
        if selectedType == type.type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = listOfTypes[indexPath.row].type
        
        selectedType = type
        
        doAfterSelection?(selectedType)
        navigationController?.popViewController(animated: true)
    }

}
