//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Uriel Hernandez Gonzalez on 15/09/22.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    // Intermediary between the app and the persistant storage
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var itemArray = [Item]()
    
    var selectedCategory: CategoryCD? {
        didSet {
            let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            loadItems(predicate: predicate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .systemBlue
        searchBar.searchTextField.backgroundColor = .white
    }
    
    private func loadItems(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            itemArray = try context.fetch(request)
            
        } catch {
            print("Error fetching data from context")
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
            
            let item = Item(context: self.context)
            item.title = textField.text!
            item.parentCategory = self.selectedCategory
            
            self.itemArray.append(item)
            
            // The app automatically persists data on the willTerminate AppDelegate method
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Could not save data")
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // [cd] means that is case and punctuation insensitive
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        loadItems(predicate: compoundPredicate, sortDescriptors: [sortDescriptor])
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            loadItems()
            
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }
    }
    
    
}
