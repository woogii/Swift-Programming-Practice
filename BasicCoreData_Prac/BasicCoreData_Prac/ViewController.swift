//
//  ViewController.swift
//  BasicCoreData_Prac
//
//  Created by siwook on 2017. 9. 8..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var itemList = [String]()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.dataSource = self
    
    navigationItem.title = "CoreData Practice"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTapped(_:)))
    
  }
  
  func buttonTapped(_ sender:Any) {
    
    let alertController = UIAlertController(title: "", message: "Type an Item", preferredStyle: .alert)
  
    let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
     
      guard let textField = alertController.textFields?.first, let text = textField.text else {
        return
      }
    
      self.itemList.append(text)
      
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
    cell.textLabel?.text = itemList[indexPath.row]
    return cell
  }
  

}

