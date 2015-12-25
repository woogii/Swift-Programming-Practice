//
//  MasterViewController.swift
//  NSKeyedArchiverPrac
//
//  Created by Hyun on 2015. 12. 1..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
 
    var objects : [AnyObject] = []
    let cellIdentifier = "Cell"
    let segueIdentifier = "showDetail"
    var detailViewController: DetailViewController? = nil
    
    var filePath : String {
        
        let defaultManager = NSFileManager.defaultManager()
        let dirPath = defaultManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return dirPath.URLByAppendingPathComponent("object array").path!
    }
    
    // MARK : - Life Cycle
    override func viewDidLoad() {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "InsertObject:")
        navigationItem.rightBarButtonItem = buttonItem
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // print(filePath)
        if let unarchivedArray = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [AnyObject] {
            objects = unarchivedArray
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    // MARK : - Insert Object 
    func InsertObject(sender:AnyObject?) {
        let item = NSDate()
        objects.insert(item, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths( [indexPath] , withRowAnimation: .Automatic)
        NSKeyedArchiver.archiveRootObject(objects, toFile: filePath)
        
    }
    
    // MARK : - Prepare Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if( segue.identifier == segueIdentifier) {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                
                let navigationVC = segue.destinationViewController as! UINavigationController
                // topViewController refers to the view controller at the top of 
                // the navigation stack. It is read-only property
                let destinationVC = navigationVC.topViewController as! DetailViewController
            
                destinationVC.detailItem = object
            }
        }
    }
    
    // MARK : - UITableViewDataSource Protocol Methods
    
    // Tells the data source to return the number of rows in a given section of a table view
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    // Asks the data source to commit the insertion or deletion of a specified row in the receiver.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete) {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if ( editingStyle == .Insert ) {
            
        }
    }

    // Asks the data source for a cell to insert in a particular location of the table view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        
        return cell
    }
    
 }
