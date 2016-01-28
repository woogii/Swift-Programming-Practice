//
//  ViewController.swift
//  MYOA
//
//  Created by Hyun on 2016. 1. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellIdentifier = "AdventureCell"
    var adventures = [Adventure]()
    var numberOfAdventure = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pathNameArray = NSBundle.mainBundle().pathsForResourcesOfType("plist", inDirectory: nil)
        
        for pathName in pathNameArray {
            
            // print((pathName as NSString).lastPathComponent)
            
            if (pathName as NSString).lastPathComponent != "Info.plist" {
                
                numberOfAdventure++
                if let contents = NSDictionary(contentsOfFile: pathName) as? [String:AnyObject] {
                    print(contents)
                    adventures.append(Adventure(dictionary: contents))
                }
            }
        }
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfAdventure
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        let item = adventures[indexPath.row]
        
        cell.textLabel!.text = item.credits.key
        cell.detailTextLabel!.text = item.credits.title 
        cell.imageView?.image =  UIImage(named:item.credits.imageName)
        
        return cell
        
    }
}

