//
//  EditOrAddTaskController.swift
//  To-Do App
//
//  Created by Костя Кодолов on 15.12.2025.
//

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
        
        self.title = "Add new task"
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
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
