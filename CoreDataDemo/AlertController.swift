//
//  AlertController.swift
//  CoreDataDemo
//
//  Created by Владимир Киселев on 20.04.2022.
//

import UIKit

extension UIAlertController {
    
    // init without preferredStyle
    static func createAlertController(withTitle title: String) -> UIAlertController {
        UIAlertController(title: title, message: "What do you want to do?", preferredStyle: .alert)
    }
    
    func action(task: Task?, completion: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            // if not null return in completion
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Task"
            // text is optional no need to extract, nil is default
            textField.text = task?.title
        }
    }
}
