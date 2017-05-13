//
//  ViewController.swift
//  UITableViewWithJSONParsing
//
//  Created by siwook on 2017. 5. 13..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  lazy var itemList:[Item] = {
    let itemList = [Item]()
    return itemList
  }()
  let dateFormat:DateFormatter = {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "YYYY-MM-dd"
    return dateFormat
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    RestClient.sharedInstance.requestImage(successCallBack: { (results) in
      
      DispatchQueue.main.async {
        self.fetchDataFromBundle()
      }
      
    }, failCallBack: { (error) in
      
    })
    
  }
  
  func fetchDataFromBundle() {
    
    if let filePath = Bundle.main.path(forResource: "items", ofType: "json") {
      
      do {
        
        let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
        let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        if let itemDict = jsonData as? [String:AnyObject], let itemDictArray = itemDict["items"] as? [[String:AnyObject]] {
          print(itemDictArray)
          itemList = Item.createItemList(dictArray: itemDictArray)
          
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        }
      } catch let error as NSError {
        print(error)
      }
    }
  }
  
  
}

extension ViewController : UITableViewDataSource {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let item = itemList[indexPath.item]
    cell.textLabel?.text = item.name
    cell.detailTextLabel?.text = dateFormat.string(from:item.releaseDate)
    cell.imageView?.image = UIImage(named: item.imageName)
    
    return cell
  }
  
}
