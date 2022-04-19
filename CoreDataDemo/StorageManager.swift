//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Владимир Киселев on 17.04.2022.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        let context = persistentContainer.viewContext
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList: [Task] = try context.fetch(fetchRequest)
            return taskList
        } catch let error {
            print("Failed to fetch data", error)
        }
        return []
    }
    
    // MARK: - Core Data Updating support
    func updateContext(_ taskToUpdate: Task) {
        let context = persistentContainer.viewContext
        let fetchRequest = Task.fetchRequest()
        
        if context.hasChanges {
            do {
//                try context.update()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }
    
    // MARK: - Core Data Deleting support
    func deleteContext(_ taskToDelete: Task) {
        let context = persistentContainer.viewContext
//        let fetchRequest = Task.fetchRequest()
        
        do {
            // let taskList: [Task] = try context.fetch(fetchRequest)
            context.delete(taskToDelete)
        } catch let error {
            print("Failed to delete data", error)
        }

    }
    
    private init() {}
}
