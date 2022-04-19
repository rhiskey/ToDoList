//
//  TaskListViewController.swift
//  CoreDataDemo
//
//  Created by Alexey Efimov on 04.10.2021.
//

import UIKit
import CoreData

protocol TaskViewControllerDelegate {
    func reloadData()
}

class TaskListViewController: UITableViewController {
    private let cellID = "task"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        taskList = StorageManager.shared.fetchData()
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @objc private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    
    private func save(_ taskName: String) {
        let context = StorageManager.shared.persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        task.title = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    
    private func edit(_ taskName: String) {
        let context = StorageManager.shared.persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        task.title = taskName
        //Replace
//        taskList.re(task)
        
//        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
//        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func deleteTask(_ taskName: String) {
        let context = StorageManager.shared.persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        task.title = ""
        
        
//        task.title = taskName
//        taskList.remove(at: task.)
        
        // TODO: delete task from table
        
        //let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        //tableView.insertRows(at: [cellIndex], with: .automatic)
        
        if context.hasChanges {
            do {
                context.delete(task)
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(taskList[indexPath.row])
        let taskInCell =  taskList[indexPath.row]
        
        showAlert(
            with: "Edit",
            and: "Do you really want to edit task?",
            on: taskInCell
        )
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskInCell =  taskList[indexPath.row]
            StorageManager.shared.deleteContext(taskInCell)
            
            showAlert(
                with: "Warning!",
                and: "Do you really want to delete task?",
                on: taskInCell
            )
        }
    }
}

// MARK: - TaskViewControllerDelegate
extension TaskListViewController: TaskViewControllerDelegate {
    func reloadData() {
        taskList = StorageManager.shared.fetchData()
        tableView.reloadData()
    }
}

extension TaskListViewController {
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    private func showAlert(with title: String, and message: String, edit task: Task) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.edit(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.addTextField { textField in
            textField.placeholder = "Edit task"
        }
        present(alert, animated: true)
    }
    
    private func showAlert(with title: String, and message: String, on task: Task) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            //guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            guard let title = task.title else { return }
            self.deleteTask(title)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true)
    }
}
