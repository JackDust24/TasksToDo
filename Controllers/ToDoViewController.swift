//
//  ViewController.swift
//  TasksToDo
//
//  Created by JasonMac on 18/2/2561 BE.
//  Copyright © 2561 JasonMac. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: SwipeTableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    // Once the row is selected in CategoryViewController will this load.
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).appendPathComponent("Items.plist")


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Just want to print where it is storing
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
   
    //MARK Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    // realm.delete(item) // if I wanted to delete it.
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status - \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.date = Date()
                    currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new item - \(error)")
                }
            }

            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        // let encoder = PropertyListEncoder()
        
//        do {
////            let data = try encoder.encode(self.itemArray)
////            try data.write(to: dataFilePath!)
//           // try context.save()
//        } catch {
//                print("Error cannot get context - \(error)")
//        }
//
        self.tableView.reloadData()
    }
    
    func loadItems() {

        print("LOAD ITEMS")
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "date", ascending: true)

//        let categoryPredicate = NSPredicate(format: "parentRelationship.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context, \(error)")
//        }

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemRow = self.toDoItems?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(itemRow) // if I wanted to delete it.
                    // self.categoryArray.delete(at: [indexPath.row])
                }
            } catch {
                print("Error saving done status - \(error)")
            }
            
            // tableView.reloadData()
            
        }
    }
    

}

extension ToDoViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

