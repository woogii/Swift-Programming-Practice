//
//  ViewController.swift
//  iOS_Interview
//
//  Created by siwook on 2017. 5. 8..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit

// MARK : - ViewController: UIViewController

class ViewController: UIViewController {

  // MARK : - Property 
  
  @IBOutlet weak var tableView: UITableView!
  var itemList = [Item]()
  let cellId = "Cell"
  let endPointUrl = "https://www.rakuten.co.jp"
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    fetchDataFromServer()
  }
  
  // MARK : - Imitating Server Request
  
  func fetchDataFromServer() {
    
    _ = RestClient.sharedInstance.getDataFromServer(urlString: endPointUrl, completionHandler: { (results, error) in
      
      if let  _ = error {
        print(error?.localizedDescription as Any)
      } else {
        
        if let _ = results {
          self.fetchDataFromBundle()
        }
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    })
    
  }
  
  // MARK : - Fetching From Bundle
  
  func fetchDataFromBundle() {
    
    if let path = Bundle.main.path(forResource:"items", ofType: "json" ) {
      
      do {
        
        let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
        
        if let dictionary = try(JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject], let itemArray = dictionary["items"] as? [[String:AnyObject]] {
          itemList = Item.createItemList(jsonArray: itemArray)
        }
      
      } catch let err {
        #if DEBUG
          print(err)
        #endif
      }
    }
  }
}


// MARK : - ViewController : UITableViewDataSource

extension ViewController : UITableViewDataSource {

  // MARK : - TableView DataSource Methods 
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    
    cell.textLabel?.text = itemList[indexPath.row].name ?? "" 
    cell.detailTextLabel?.text = itemList[indexPath.row].releaseDate
    cell.imageView?.image = UIImage(named:itemList[indexPath.row].imageName)
    
    return cell
  }
  
  
}

