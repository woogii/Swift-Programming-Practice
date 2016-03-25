//
//  ShoppingListViewController.swift
//  ShoppingList
//
//  Created by Hyun on 2016. 3. 12..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListviewController: UIViewController {
    
    // MARK : Properties
    @IBOutlet weak var tableView: UITableView!
    

    let cellIdentifier = "itemNameList"
    var selectedItem:String?

    // MARK : Property Observers
    var items = [Item]() {
        didSet {
            buildShoppingList()
        }
    }
    
    var shoppingList = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK : View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadItems()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateShoppingList:", name: shoppingListAddNotification, object: nil)
        
    }
    
    func updateShoppingList(notification: NSNotification) {
        loadItems()
    }
    
    // MARK : Helper Methods
    func loadItems() {
        items = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [Item] ?? [Item]()
    }
    
    func saveItem() {
        NSKeyedArchiver.archiveRootObject(shoppingList, toFile: filePath)
    }
        
    var filePath : String {
        
        let fileName = "itemList"
        
        let documentDirectoryURL : NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        return documentDirectoryURL.URLByAppendingPathComponent(fileName).path!
    }
    
    // MARK : UITableView DataSource Methods
    func buildShoppingList() {
        // shoppingList property observer is executed right after this line of code
        shoppingList = items.filter( {  $0.isShoppingList == true })  // returns an array that holds true in boolean variable
    }
    
    
}

extension ShoppingListviewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK : UITableView DataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        let item = shoppingList[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
}