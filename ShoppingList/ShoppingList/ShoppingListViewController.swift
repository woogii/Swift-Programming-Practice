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
    

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "itemNameList"
    var selectedItem:String?
    
    var shoppingList = [Item]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addList:", name: shoppingListAddNotification, object: nil)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("remove notification")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: shoppingListAddNotification, object: nil)
    }
    
    func addList(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        if let item = userInfo![selectedKey] as? String {
            selectedItem = item
            print(selectedItem)
        }
    }
    
    
}

extension ShoppingListviewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        // cell.textLabel?.text = shoppingList[0]
        
        return cell
    }
}