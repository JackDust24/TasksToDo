//
//  SwipeTableViewController.swift
//  TasksToDo
//
//  Created by JasonMac on 25/2/2561 BE.
//  Copyright © 2561 JasonMac. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("CellRow")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Row Deleted")
            
            self.updateModel(at: indexPath)
            
//            if let categoryRow = self.categoryArray?[indexPath.row] {
//
//                do {
//                    try self.realm.write {
//                        self.realm.delete(categoryRow) // if I wanted to delete it.
//                        // self.categoryArray.delete(at: [indexPath.row])
//                    }
//                } catch {
//                    print("Error saving done status - \(error)")
//                }
//
//                // tableView.reloadData()
//
//            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        // options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }


}
