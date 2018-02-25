//
//  CategoryViewController.swift
//  TasksToDo
//
//  Created by JasonMac on 23/2/2561 BE.
//  Copyright © 2561 JasonMac. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none

        loadCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
        
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        print("CellRow")
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category yet"
        
        let cellColorString = categoryArray?[indexPath.row].cellColor ?? randomColorForCell()
        cell.backgroundColor = UIColor(hexString: cellColorString)
        
        // cell.accessoryType = category.done ? .checkmark : .none
        
        return cell
    }
    
    func randomColorForCell() -> String {
        
        let randomColor = UIColor.randomFlat.hexValue()

        return randomColor
    }
    

    //MARK: - Table View Delegate

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("*** DID SELECT DIDSELECTROW ***")

        performSegue(withIdentifier: "AddCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("*** prepare for segue ***")
    
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("ADD CATEGORY")
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.cellColor = self.randomColorForCell()
            self.saveItems(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(category: Category) {
        print("SAVE CATEGORY")
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error cannot get context - \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategory() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {

        if let categoryRow = self.categoryArray?[indexPath.row] {

            do {
                try self.realm.write {
                    self.realm.delete(categoryRow) // if I wanted to delete it.
                    // self.categoryArray.delete(at: [indexPath.row])
                }
            } catch {
                print("Error saving done status - \(error)")
            }

            // tableView.reloadData()

        }
    }
    
//    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//
////        print("LOAD CATEGORY")
////
////        
////        do {
////            categoryArray = try context.fetch(request)
////        } catch {
////            print("Error fetching data from context, \(error)")
////
////        }
////
////        tableView.reloadData()
//    }
    


}


