//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Uriel Hernandez Gonzalez on 20/09/22.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    private let realm = try! Realm()
    private var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    private func loadCategories() {
        categories = realm.objects(Category.self)
    }
    

    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destionationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    @IBAction func onClickedAddCategory(_ sender: UIBarButtonItem) {
        
        let alert = createAddCategoryAlert()
        
        present(alert, animated: true)
    }
    
    private func createAddCategoryAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Category Name"
        }
        
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { action in
            let category = Category()
            category.name = alert.textFields!.first!.text!
            self.save(category: category)
        }
        
        alert.addAction(alertAction)

        return alert
    }
    
    private func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            tableView.reloadData()
        } catch {
            print("Failed to save categories")
        }
    }
}
