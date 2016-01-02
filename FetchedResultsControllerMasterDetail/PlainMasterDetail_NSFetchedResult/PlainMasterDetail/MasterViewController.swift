//
//  MasterViewController.swift
//  throwawayMD
//
//  Created by Jason on 3/18/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        do  {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
            abort()
        }
        
        // Set this view controller as the fetched results controller's delegate
        fetchedResultsController.delegate = self
    }
    
    // MARK : - NSFetchedResultsController Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // This invocation prepares the table to receive a number of changes. It will store them up 
        // until it receives endUpdates(), and then perform them all at once.
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    // When endUpdates() is invoked, the table makes the changes visible.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
        
    lazy var sharedContext =  {
       return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    lazy var fetchedResultsController : NSFetchedResultsController = {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Event")
        
        // Add a sort descriptor
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"timeStamp", ascending: false)]
        
        // Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil )
        
        // Return the fetched results controller. It will be the value of the lazy variable
        return fetchedResultsController
    }()
    
    func insertNewObject(sender: AnyObject) {
        
        let event = Event(context: sharedContext)
        event.timeStamp = NSDate()
        CoreDataStackManager.sharedInstance().saveContext()
        
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
        
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let object = fetchedResultsController.objectAtIndexPath(indexPath)
                (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return objects.count
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get event from fetchedResultController
        let event = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Event
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        // let object = objects[indexPath.row] as! Event
        cell.textLabel!.text = event.timeStamp.description
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let event = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Event
            sharedContext.deleteObject(event)
            
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    

}

