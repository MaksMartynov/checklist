//
//  ViewController.swift
//  CheckList
//
//  Created by ale on 22.04.2020.
//  Copyright © 2020 ale. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    var items: [ChecklistItem]
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
        row0item.text = "Walk with dog"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Brush teeth"
        row1item.checked = true
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "learn iOS development"
        row2item.checked = true
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = true
        items.append(row4item)
        
        let row5item = ChecklistItem()
        row5item.text = "WorkOut"
        row5item.checked = false
        items.append(row5item)
        
        super.init(coder: aDecoder)
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toogleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveChecklistItems()
    }

    override func tableView(_ tableView: UITableView,
                            commit edititngStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        saveChecklistItems()
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    //Setting the delegate
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "AddItem" {
              let navigationController = segue.destination as! UINavigationController
            
              let controller = navigationController.topViewController as! ItemDetailViewController
              controller.delegate = self
          } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            //разворачиваю опциональное значение и нахожу номер строки, объект UITableViewCell используется для этого
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
      }
      
      func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
          dismiss(animated: true, completion: nil)
      }
    
      func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
          let newRowIndex = items.count
          items.append(item)
          
          let indexPath = IndexPath(row: newRowIndex, section: 0)
          let indexPaths = [indexPath]
          tableView.insertRows(at: indexPaths, with: .automatic)
        
          dismiss(animated: true, completion: nil)
        
        saveChecklistItems()
      }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        
        saveChecklistItems()
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
}





