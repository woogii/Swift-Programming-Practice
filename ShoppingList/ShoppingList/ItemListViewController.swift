//
//  ViewController.swift
//  ShoppingList
//
//  Created by Hyun on 2016. 3. 12..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit


let shoppingListAddNotification = "notificationKey"
let selectedKey = "selectedKey"

class ItemListViewController: UIViewController, ItemAddViewControllerDelegate {

    // MARK : - Property
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "itemCell"
    var items = [Item]()
    var selectedItem:Item?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadItems()
    }

    
    // MARK : - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addItemList", name: shoppingListAddNotification, object: nil)
    }
    
    func loadItems()
    {
        // The nil-coalescing operator a ?? b is a shortcut for a != nil ? a! : b
        // It returns either the left operand unwrapped or the right operand
        items = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [Item] ?? [Item]()
    }
    
    func addItemList() {
        
    }
    
    func configureUI() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem:")
        
        self.navigationItem.leftBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem = editButtonItem()
    
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func addItem(barButtonItem: UIBarButtonItem) {
        
        performSegueWithIdentifier("showAddView", sender: self)
    }
    
    func addItemInList(controller: ItemAddViewController, item: Item) {
        
        items.append(item)
        
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: items.count-1, inSection: 0)], withRowAnimation: .None)
        saveItem()
    }
    
    // MARK : Segue 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if( segue.identifier == "showAddView") {
            
            let naviController = segue.destinationViewController as! UINavigationController
            let itemAddViewController = naviController.topViewController as! ItemAddViewController
            itemAddViewController.delegate = self
            
        } else if ( segue.identifier == "showDetailView") {
            
            let controller = segue.destinationViewController as! ItemDetailViewController
            controller.item = selectedItem
            
        }
    }
    
    func saveItem()
    {
        NSKeyedArchiver.archiveRootObject(items, toFile: filePath)
    }
    
    // MARK : Computed Property
    var filePath : String {
        
        let fileName = "itemList"
        
        let documentDirectoryURL:NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        // Returns a new URL made by appending a path component to the original URL.
        // The path component to add to the URL, in its original form (not URL encoded).
        return documentDirectoryURL.URLByAppendingPathComponent(fileName).path!

    }
    
}

extension ItemListViewController : UITableViewDelegate, UITableViewDataSource {

    // MARK : UITableView DataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel!.text = item.name
        
        if item.isShoppingList {
            // optional chaining
            cell.imageView?.image = UIImage(named:"checkmark")
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            saveItem()
        } 
        
    }
    
    // MARK : UITableView Delegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        // Get a selected item
        let item = items[indexPath.row]
        
        // Change the value of 'isShoppingList' variable to the opposite boolean value
        item.isShoppingList = !item.isShoppingList
        
        if item.isShoppingList {
            cell?.imageView?.image = UIImage(named: "checkmark")
        
        } else {
            cell?.imageView?.image = nil
        }
        
        saveItem()
        
        NSNotificationCenter.defaultCenter().postNotificationName(shoppingListAddNotification, object: self)
    }
    
    // Tell the delegate that the user tapped the accessory (disclosure) view associated with a given row
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        // Save the selected item to variable
        selectedItem = items[indexPath.row]
        performSegueWithIdentifier("showDetailView", sender: indexPath)
    }
    
    // MARK : UIViewController Method
    // Toggle the table view into and out of editing mode
    override func setEditing(editing: Bool, animated: Bool) {
        tableView.setEditing(!tableView.editing, animated: animated)
    }
    

}
