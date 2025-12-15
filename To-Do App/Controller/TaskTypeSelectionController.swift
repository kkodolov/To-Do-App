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
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 80
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
