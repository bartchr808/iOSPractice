//
//  ListTableViewController.swift
//  TodoList
//
//  Created by Bart Chrzaszcz on 2017-12-28.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var onListSelected: ((_ list: List) -> Void)?
    var todosDataStore: TodosDataStore?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lists"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = todosDataStore?.lists()[indexPath.row]
        if let list = list, let onListSelected = onListSelected {
            onListSelected(list)
        }
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosDataStore?.lists().count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let list = todosDataStore?.lists()[indexPath.row] {
            cell.textLabel?.text = list.description
        }
        
        cell.selectionStyle = .none

        return cell
    }
}

// MARK: - Actions
extension ListTableViewController {
    @IBAction func addListButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Enter list name", message: "To create a new list, please enter the name of the list", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) -> Void in
                let textField = alert.textFields?.first
            self.addList(description: textField?.text ?? "")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    func addList(description: String) {
        todosDataStore?.addListDescription(description: description)
        tableView.reloadData()
    }
}
