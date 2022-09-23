//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Uriel Hernandez Gonzalez on 15/09/22.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    private let realm = try! Realm()
    private var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .systemBlue
        searchBar.searchTextField.backgroundColor = .white
    }
    
    private func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = items?[indexPath.row].title
        cell.accessoryType = (items?[indexPath.row].isDone) ?? false ? .checkmark : .none
        cell.selectionStyle = .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        try! realm.write {
            items?[indexPath.row].isDone.toggle()
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
    
    @IBAction func onClickedAddItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: nil, preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let item = Item()
            item.title = textField.text!
            self.save(item: item)
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func save(item: Item) {
        do {
            try realm.write {
                realm.add(item)
                self.selectedCategory?.items.append(item)
            }
            tableView.reloadData()
        } catch {
            print("Could not save data")
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?
            .filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "title", ascending: true)
        
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
