//
//  ViewController.swift
//  MYOA
//
//  Created by Hyun on 2016. 1. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK : - Property
    let cellIdentifier = "AdventureCell"
    var adventures = [Adventure]()

    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pathNameArray = NSBundle.mainBundle().pathsForResourcesOfType("plist", inDirectory: nil)
        
        for pathName in pathNameArray {
            
            if (pathName as NSString).lastPathComponent != "Info.plist" {
                
                // Initializes a newly allocated dictionary using the keys and values found in a file at a given path
                if let contents = NSDictionary(contentsOfFile: pathName) as? [String:AnyObject] {
                    
                    adventures.append(Adventure(dictionary: contents))
                }
            }
        }
    }


    // MARK : - UITableViewDelegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adventures.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        let item = adventures[indexPath.row]
        
        cell.textLabel!.text = item.credits.key
        cell.detailTextLabel!.text = item.credits.title 
        cell.imageView?.image =  UIImage(named:item.credits.imageName)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Get the selected adventure
        let adventure = adventures[indexPath.row]
        
        let storyController = storyboard?.instantiateViewControllerWithIdentifier("StoryNodeViewController") as!
            StoryNodeViewController
    
        // Set the current node as a start node so that 
        // we will start with a first story node in each 
        // adventure
        storyController.currentNode = adventure.startNode
        
        // Push the new controller onto the stack
        self.navigationController?.pushViewController(storyController, animated: true)
    
    }
}

