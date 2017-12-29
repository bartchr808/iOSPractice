//
//  TodosDataStore.swift
//  TodoList
//
//  Created by Bart Chrzaszcz on 2017-12-27.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import Foundation

class TodosDataStore {
    private var savedLists = [List]()
    private var savedTodos = [Todo]()
    
    init() {
        /*savedLists = [
            List(description: "Personal"),
            List(description: "Work"),
            List(description: "Family")
        ]
        
        savedTodos = [
            Todo(description: "Remember the Milk",
                 list: List(description: "Family"),
                 dueDate: NSDate(),
                 done: false,
                 doneDate: nil
            ),
            Todo(description: "But Spider Man Comics",
                 list: List(description: "Personal"),
                 dueDate: NSDate(),
                 done: true,
                 doneDate: NSDate()
            ),
            Todo(description: "Release build",
                 list: List(description: "Work"),
                 dueDate: NSDate(),
                 done: false,
                 doneDate: nil)
        ]*/
    }
    
    func todos() -> [Todo] {
        return savedTodos
    }
    
    func lists() -> [List] {
        return [defaultList()] + savedLists
    }
}

// MARK: Actions
extension TodosDataStore {
    func addTodo(todo: Todo) {
        savedTodos += [todo]
    }
    func deleteTodo(todo: Todo?) {
        if let todo = todo {
            savedTodos = savedTodos.filter({ $0 != todo })
        }
    }
    
    func doneTodo(todo: Todo) {
        deleteTodo(todo: todo)
        let doneTodo = Todo(description: todo.description, list: todo.list, dueDate: todo.dueDate, done: true, doneDate: NSDate())
        addTodo(todo: doneTodo)
    }
    
    func addListDescription(description: String) {
        if !description.isEmpty {
            savedLists += [List(description: description)]
        }
    }
}


// MARK: Defaults
extension TodosDataStore {
    func defaultList() -> List {
        return List(description: "Personal")
    }
    
    func defaultDueDate() -> NSDate {
        let now = NSDate()
        let secondsInADay = TimeInterval(24 * 60 * 60)
        return now.addingTimeInterval(secondsInADay)
    }
}
