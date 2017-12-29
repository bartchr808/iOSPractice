//
//  TodoTableViewController.swift
//  TodoList
//
//  Created by Bart Chrzaszcz on 2017-12-27.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit
import MGSwipeTableCell

@objc(TodoTableViewController)
class TodoTableViewController: UITableViewController {
    
    private var todosDataStore: TodosDataStore?
    private var todos: [Todo]?
    private var selectedTodo: Todo?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todos"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Internal Functions
    private func refresh() {
        if let todosDataStore = todosDataStore {
            todos = todosDataStore.todos().sorted{
                $0.dueDate.compare($1.dueDate as Date) == ComparisonResult.orderedAscending
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Configure
    func configure(todosDataStore: TodosDataStore) {
        self.todosDataStore = todosDataStore
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! MGSwipeTableCell
        
        if let todo = todos?[indexPath.row] {
            renderCell(cell: cell, todo: todo)
            setupButtonsForCell(cell: cell, todo: todo)
        }
        
        return cell
    }
    
    // MARK: Cell Helpers
    private func renderCell(cell: UITableViewCell, todo: Todo) {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-YY"
        let dueDate = dateFormatter.string(from: todo.dueDate as Date)
        cell.detailTextLabel?.text = "\(dueDate) | \(todo.list.description)"
        cell.textLabel?.text = todo.description
        cell.accessoryType = todo.done ? .checkmark : .none
    }
    
    private func setupButtonsForCell(cell: MGSwipeTableCell, todo: Todo) {
        cell.rightButtons = [
            MGSwipeButton(title: "Edit", backgroundColor: .blue, padding: 30) {
                [weak self] sender in
                self?.editButtonPressed(todo: todo)
                return true
            },
            MGSwipeButton(title: "Delete", backgroundColor: .red, padding: 30) {
                [weak self] sender in
                self?.deleteButtonPressed(todo: todo)
                return true
            },
            MGSwipeButton(title: "Done", backgroundColor: .green, padding: 30) {
                [weak self] sender in
                self?.doneButtonPressed(todo: todo)
                return true
            }
        ]
        cell.leftExpansion.buttonIndex = 0
    }
}

// MARK: - Actions
extension TodoTableViewController {
    @IBAction func addTodoButtonPressed(sender: AnyObject!) {
        performSegue(withIdentifier: "addTodo", sender: self)
    }
    
    func editButtonPressed(todo: Todo){
        selectedTodo = todo
        performSegue(withIdentifier: "editTodo", sender: self)
    }
    
    func deleteButtonPressed(todo: Todo) {
        todosDataStore?.deleteTodo(todo: todo)
        refresh()
    }
    
    func doneButtonPressed(todo: Todo) {
        todosDataStore?.doneTodo(todo: todo)
        refresh()
    }
}

// MARK: Segue
extension TodoTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let destinationViewController = segue.destination as? EditTodoTableViewController else {
            return
        }
        
        destinationViewController.todosDataStore = todosDataStore
        destinationViewController.todoToEdit = selectedTodo
        
        switch identifier {
            case "addTodo":
                destinationViewController.title = "New Todo"
            case "editTodo":
                destinationViewController.title = "Edit Todo"
            default:
                break
        }
    }
}
