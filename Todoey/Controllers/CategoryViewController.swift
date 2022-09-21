//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Uriel Hernandez Gonzalez on 20/09/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var categories = [CategoryCD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    private func loadCategories(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        let request: NSFetchRequest<CategoryCD> = CategoryCD.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching categories")
        }
    }
    

    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
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
            destionationVC.selectedCategory = categories[indexPath.row]
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
            let category = CategoryCD(context: self.context)
            category.name = alert.textFields?.first?.text!
            self.categories.append(category)
            self.saveData()
        }
        
        alert.addAction(alertAction)

        return alert
    }
    
    private func saveData() {
        do {
            try context.save()
        } catch {
            print("Could not save categories")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
