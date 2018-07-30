//
//  ViewController.swift
//  JustInTodo
//
//  Created by Justin Zhang on 2018/7/28.
//  Copyright © 2018年 JustinZhang. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    // MARK: - Init variables/constants
    
    
    let defaults = UserDefaults.standard

    var itemArray : [String] = []
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
    }
    
    //MARK: - Add new item methods
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message: "Add a new item here", preferredStyle: .alert)
        
        // the button that allow user to press and then the action it will make.
        let addItemAction = UIAlertAction(title: "Add item", style: .default) {(action) in
            
            // what will happen once the user clicks the Add item button on our UIAlert
            if let tfText = textField.text {
                
                self.itemArray.append(tfText)
                
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
                self.tableView.reloadData()
            } else {
                print("text field is empty!")
            }
        }
        
        // add text field in Alert view
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            alertTextField.text = nil
            alertTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange(field:)), for: UIControlEvents.editingChanged)
            textField = alertTextField
        }
        
        addItemAction.isEnabled = false
        alert.addAction(addItemAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // The listener for alert text field to judge if the textfield is empty or not.
    @objc func alertTextFieldDidChange(field: UITextField) {
        let alertControllor : UIAlertController = self.presentedViewController as! UIAlertController
        let textField : UITextField = alertControllor.textFields![0]
        let addAction : UIAlertAction = alertControllor.actions[0]
        let textLength = textField.text?.count
        addAction.isEnabled = textLength! > 0
    }

}

