//
//  ViewController.swift
//  BasicCoreData_Prac
//
//  Created by siwook on 2017. 9. 8..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var itemList = [Item]()
  var appDelegate : AppDelegate  {
    return UIApplication.shared.delegate as! AppDelegate
  }
  // var managedContext : NSManagedObjectContext
  let coreDataStack = CoreDataStack()
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.dataSource = self
    
    navigationItem.title = "CoreData Practice"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTapped(_:)))
    fetchData()
  }
  
  private func fetchData() {
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
    
    do {
      guard let fetchedResult = try coreDataStack.managedContext.fetch(fetchRequest) as? [Item] else {
        return
      }
      
      itemList = fetchedResult
      
      self.tableView.reloadData()
    } catch let error as NSError {
      print("Fetch error..\(error.userInfo)..\(error.localizedDescription)")
    }
    
  }
  
  func buttonTapped(_ sender:Any) {
    
    let alertController = UIAlertController(title: "", message: "Type an Item", preferredStyle: .alert)
  
    let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
     
      guard let textField = alertController.textFields?.first, let text = textField.text else {
        return
      }
      
      guard let entityDesc = NSEntityDescription.entity(forEntityName: "Item", in: self.coreDataStack.managedContext) else {
        return
      }
      
      let item = Item(entity: entityDesc, insertInto: self.coreDataStack.managedContext)
      item.desc = text
      
      self.itemList.append(item)
      self.coreDataStack.save()
      
      DispatchQueue.main.async {
        
        self.tableView.reloadData()
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    
    alertController.addTextField { (textField) in
      textField.placeholder = "Enter your item"
    }
    
    present(alertController, animated: true, completion: nil)
    
  }
  


}

extension ViewController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = itemList[indexPath.row].desc
    return cell
  }
  

}

