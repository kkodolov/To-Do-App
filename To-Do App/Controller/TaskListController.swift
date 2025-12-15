import UIKit

class TaskListController: UITableViewController {
    
    var taskStorage: TaskStorageProtocol = TaskStorage()
    var tasks: [TaskType: [TaskProtocol]] = [:] {
        didSet {
            let array = tasks.values.flatMap { $0 }
            taskStorage.save(tasks: array)
        }
    }
    var selectedType: [TaskType] = [.important, .normal]

    override func viewDidLoad() {
        super.viewDidLoad()
               
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "infoCell")
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    func setTasks(_ tasksCollection: [TaskProtocol]) {
        selectedType.forEach { type in
            tasks[type] = []
        }
        
        tasksCollection.forEach { task in
            tasks[task.type]?.append(task)
        }
        
        sortTasks()
    }
    
    private func sortTasks() {
        for (taskType, task) in tasks {
            tasks[taskType] = task.sorted(by: { $0.status.rawValue < $1.status.rawValue })
        }
    }
    
    // ADD NEW TASK
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "toEditScreen" else { return }
        let editScreen = segue.destination as! EditOrAddTaskController
        editScreen.doAfterEditing = { [unowned self] title, type, status in
            tasks[type]?.append(Task(title: title, type: type, status: status))
            sortTasks()
            tableView.reloadData()
        }
        editScreen.title = "Add new task"
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
        let count = tasks[type]?.count ?? 0
        return count == 0 ? 1 : count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = selectedType[indexPath.section]
        let isEmpty = tasks[type]?.isEmpty ?? true
        
        if isEmpty {
            return getInfoCell(by: indexPath)
        } else {
            return getConfiguredCell(by: indexPath)
        }
    }
    
    private func getInfoCell(by indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        config.text = "No tasks in the current type"
        config.textProperties.alignment = .center
        config.textProperties.color = .secondaryLabel
        cell.contentConfiguration = config
        
        cell.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        
        return cell
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

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actionsConfiguration = UISwipeActionsConfiguration()
        let taskType = selectedType[indexPath.section]
        guard let task = tasks[taskType]?[indexPath.row] else { return nil }
        
        // EDIT EXISTING TASK
        let editTaskAction = UIContextualAction(
            style: .normal,
            title: "Edit") { _, _, _ in
                let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editScreen") as! EditOrAddTaskController
                editScreen.taskTitle = task.title
                editScreen.taskType = task.type
                editScreen.taskStatus = task.status
                editScreen.doAfterEditing = { [unowned self] title, type, status in
                    let editedTask = Task(title: title, type: type, status: status)
                    if taskType == type {
                        tasks[taskType]![indexPath.row] = editedTask
                    } else {
                        tasks[taskType]!.remove(at: indexPath.row)
                        tasks[type]!.append(editedTask)
                    }
                    sortTasks()
                    tableView.reloadData()
                }
                editScreen.title = "Edit task"
                self.navigationController?.pushViewController(editScreen, animated: true)
            }
        editTaskAction.backgroundColor = .systemMint
        
        let changeStatusAction = UIContextualAction(
            style: .normal,
            title: "Not completed") { _, _, _ in
                if task.status == .completed {
                    self.tasks[taskType]![indexPath.row].status = .planned
                    tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
                }
            }
        changeStatusAction.backgroundColor = .lightGray
        
        if task.status == .completed {
            actionsConfiguration = UISwipeActionsConfiguration(actions: [changeStatusAction, editTaskAction])
        } else {
            actionsConfiguration = UISwipeActionsConfiguration(actions: [editTaskAction])
        }
        return actionsConfiguration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = selectedType[indexPath.section]
        guard let taskType = tasks[type], !taskType.isEmpty else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        guard let task = tasks[type]?[indexPath.row] else { return }
        
        if task.status == .planned {
            tasks[type]![indexPath.row].status = .completed
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let type = selectedType[indexPath.section]
        return !(tasks[type]?.isEmpty ?? true)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let type = selectedType[indexPath.section]
        return !(tasks[type]?.isEmpty ?? true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let type = selectedType[indexPath.section]
        guard var tasksInSection = tasks[type], !tasksInSection.isEmpty else { return }
        
        tasksInSection.remove(at: indexPath.row)
        tasks[type] = tasksInSection
        
        if tasksInSection.isEmpty {
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let typeFrom = selectedType[fromIndexPath.section]
        let typeTo = selectedType[to.section]
        
        guard let movedItem = tasks[typeFrom]?[fromIndexPath.row] else { return }
        
        tasks[typeFrom]!.remove(at: fromIndexPath.row)
        tasks[typeTo]!.insert(movedItem, at: to.row)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if originalIndexPath.section != proposedIndexPath.section {
            return originalIndexPath
        }
        return proposedIndexPath
    }
}
