import UIKit

class EditOrAddTaskController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var switchLabel: UISwitch!
    @IBOutlet weak var saveLabel: UIBarButtonItem!
    
    var taskTitle: String = ""
    var taskType: TaskType = .normal
    var taskStatus: TaskStatus = .planned
    
    var doAfterEditing: ((String, TaskType, TaskStatus) -> Void)?
    
    private var taskTypes: [TaskType: String] = [
        .important: "Important",
        .normal: "Normal"
    ]
    private var trimmedTitle: String {
        textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        textField.text = taskTitle
        taskTypeLabel.text = taskTypes[taskType]
        switchLabel.isOn = taskStatus == .completed ? true : false
        saveLabel.isEnabled = !trimmedTitle.isEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "toTypeSelectionScreen" else { return }
        let typeSelectionVC = segue.destination as! TaskTypeSelectionController
        typeSelectionVC.selectedType = taskType
        typeSelectionVC.doAfterSelection = { [unowned self] type in
            taskType = type
            taskTypeLabel.text = taskTypes[taskType]
        }
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let title = trimmedTitle.isEmpty ? "No name" : trimmedTitle
        let type: TaskType = taskType
        let status: TaskStatus = switchLabel.isOn ? .completed : .planned
        doAfterEditing?(title, type, status)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        saveLabel.isEnabled = !trimmedTitle.isEmpty
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
}
