//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Uriel Hernandez Gonzalez on 15/09/22.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    private let dataFilePath = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    private var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    private func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                itemArray = try PropertyListDecoder().decode([Item].self, from: data)
            } catch {
                print("Error obtaining the items")
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].isDone ? .checkmark : .none
        cell.selectionStyle = .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isDone.toggle()
        tableView.reloadRows(at: [indexPath], with: .fade)
        saveItems()
    }
    
    
    
    @IBAction func onClickedAddItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: nil, preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            self.itemArray.append(Item(title: textField.text!))
            
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func saveItems() {
        do {
            let itemsData = try PropertyListEncoder().encode(itemArray)
            try itemsData.write(to: dataFilePath!)
        } catch {
            print("Could not save data")
        }
    }
}
