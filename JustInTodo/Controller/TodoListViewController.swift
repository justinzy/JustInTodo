//
//  ViewController.swift
//  JustInTodo
//
//  Created by Justin Zhang on 2018/7/28.
//  Copyright © 2018年 JustinZhang. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    // MARK: - Init variables/constants
    var itemArray : [Item] = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(dataFilePath!)
        loadItems()
    }
    
   
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.titile
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()     
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].titile)
    }
    
    //MARK: - Add new item methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message: "Add a new item here", preferredStyle: .alert)
        
        // the button that allow user to press and then the action it will make.
        let addItemAction = UIAlertAction(title: "Add item", style: .default) {(action) in
            
            // what will happen once the user clicks the Add item button on our UIAlert
            if let tfText = textField.text {
                let newItem = Item()
                newItem.titile = tfText
                
                self.itemArray.append(newItem)
                
                self.saveItems()
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
    
    // MARK: - Model Manupulation Methods
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding: \(error)")
            }
        }
    }

}

