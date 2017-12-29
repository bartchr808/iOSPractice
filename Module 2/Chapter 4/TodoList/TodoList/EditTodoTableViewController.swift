//
//  EditTodoTableViewController.swift
//  TodoList
//
//  Created by Bart Chrzaszcz on 2017-12-28.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit

class EditTodoTableViewController: UITableViewController {
    
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var listLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    var todoToEdit: Todo?
    var todosDataStore: TodosDataStore?
    private var list: List?
    private var dueDate: NSDate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        refresh()
        descriptionTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Internal Functions
private extension EditTodoTableViewController {
    func setup() {
        if let todo = todoToEdit {
            descriptionTextField.text = todo.description
            list = todo.list
            dueDate = todo.dueDate
        } else if let todosDataStore = todosDataStore {
            list = todosDataStore.defaultList()
            dueDate = todosDataStore.defaultDueDate()
        }
        datePickerSetup()
    }
    
    func datePickerSetup() {
        dueDatePicker.datePickerMode = .dateAndTime
        dueDatePicker.minimumDate = NSDate() as Date
        dueDatePicker.date = dueDate! as Date
        dueDatePicker.addTarget(self, action: #selector(dueDateChanged), for: .valueChanged)
    }
}

// Mark: - Actions
extension EditTodoTableViewController {
    @objc func dueDateChanged() { // ???: sender: UIButton!
        dueDate = dueDatePicker.date as NSDate
        refresh()
    }
    
    func refresh() {
        listLabel.text = "List: \(list!.description)"
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-YY"
        if let dueDate = dueDate {
            let formattedDueDate = dateFormatter.string(from: dueDate as Date)
            dueDateLabel.text = "Due date: \(formattedDueDate)"
        }
    }
    
    func doneSelected() {
        if let descriptionText = descriptionTextField.text, let list = list, let dueDate = dueDate, !descriptionText.isEmpty {
            let newTodo = Todo(description: descriptionText, list: list, dueDate: dueDate, done: false, doneDate: nil)
            todosDataStore?.addTodo(todo: newTodo)
            todosDataStore?.deleteTodo(todo: todoToEdit)
            navigationController!.popViewController(animated: true)
        }
    }
    
    func showAddList() {
        performSegue(withIdentifier: "addList", sender: self)
    }
}

enum EditTableViewRow: Int {
    case Description
    case List
    case DueDate
    case Done
    case DatePicker
}

// MARK: - UITableViewDelegate
extension EditTodoTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch EditTableViewRow(rawValue: indexPath.row)! {
        case .List:
            showAddList()
        case .DueDate:
            descriptionTextField.resignFirstResponder()
        case .Done:
            doneSelected()
        default:
            break
        }
    }
}

// MARK: - Segue
extension EditTodoTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let destinationViewController = segue.destination as? ListTableViewController else {
            return
        }
        
        if identifier == "addList" {
            destinationViewController.title = "Lists"
            destinationViewController.todosDataStore = todosDataStore
            destinationViewController.onListSelected = { list in
                self.list = list
                self.refresh()
            }
        }
    }
}
