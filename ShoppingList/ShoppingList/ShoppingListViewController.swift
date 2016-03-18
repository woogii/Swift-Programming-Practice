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
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addToShoppingList:", name: shoppingListAddNotification, object: nil)
    }
    
    func addToShoppingList(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        
        selectedItem = userInfo![selectedKey] as? String
        print(selectedItem)
    }
    
    
}

extension ShoppingListviewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        return cell
    }
}