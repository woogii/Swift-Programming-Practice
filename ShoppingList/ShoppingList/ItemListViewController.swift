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
    

    
    // MARK : - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addShoppingListNotification", name: shoppingListAddNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadItems()
    }
    
    func loadItems()
    {
        // The nil-coalescing operator a ?? b is a shortcut for
        // a != nil ? a! : b
        // It returns either the left operand unwrapped or the right operand
        items = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [Item] ?? [Item]()
    }
    
    func addShoppingListNotification() {
        print("notification")
    }
    
    func configureUI() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem:")
        //let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editItem:")
        
        self.navigationItem.leftBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem = editButtonItem()
        

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    func addItem(barButtonItem: UIBarButtonItem) {
        //let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ItemAddViewController")
        // as! ItemAddViewController
        // presentViewController(controller, animated: true, completion: nil)
        performSegueWithIdentifier("showAddView", sender: self)
    }
    
    func addItemInList(controller: ItemAddViewController, item: Item) {
        items.append(item)
        
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: items.count-1, inSection: 0)], withRowAnimation: .None)
        saveItem()
        // tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if( segue.identifier == "showAddView") {
            
            let naviController = segue.destinationViewController as! UINavigationController
            let itemAddViewController = naviController.topViewController as! ItemAddViewController
            itemAddViewController.delegate = self
            
        } else if ( segue.identifier == "showDetailView") {
            
            let controller = segue.destinationViewController as! ItemDetailViewController

            if let indexPath = sender as? NSIndexPath {
             
                print(indexPath.row)
                controller.item = Item(price: items[indexPath.row].price, name: items[indexPath.row].name)
            }
            
        }
    }
    
    func saveItem()
    {
        NSKeyedArchiver.archiveRootObject(items, toFile: filePath)
    }
    
    var filePath : String {
        
        let fileName = "itemList"
        
        let documentDirectoryURL:NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        // Returns a new URL made by appending a path component to the original URL.
        // The path component to add to the URL, in its original form (not URL encoded).
        return documentDirectoryURL.URLByAppendingPathComponent(fileName).path!

    }
    
}

extension ItemListViewController : UITableViewDelegate, UITableViewDataSource {
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel!.text = items[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {

        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell?.imageView?.image == nil {
            cell?.imageView?.image = UIImage(named: "checkmark")
        
        } else {
            cell?.imageView?.image = nil
        }
        
        // let userInfo = NSDictionary(object: items[indexPath.row].name, forKey: "itemName")
        // var userInfo = [String:String]()
        // userInfo[selectedKey] = items[indexPath.row].name
        
        
        items[indexPath.row].isShoppingList = true
        saveItem()
        
        NSNotificationCenter.defaultCenter().postNotificationName(shoppingListAddNotification, object: self)
        
      
    }
    
    // Tell the delegate that the user tapped the accessory (disclosure) view associated with a given row
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {

        performSegueWithIdentifier("showDetailView", sender: indexPath)
    }
    
    // Toggle the table view into and out of editing mode
    override func setEditing(editing: Bool, animated: Bool) {
        tableView.setEditing(!tableView.editing, animated: animated)
        // super.setEditing(editing, animated: animated)
    }
    

}
