//
//  ViewController.swift
//  FavoriteThings
//
//  Created by Jason Schatz on 11/18/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "FavoriteThingCell"

    // Model
    
    let favoriteThings = [
        "Raindrops on roses",
        "Whiskers on kittens",
        "Bright copper kettles",
        "Warm woolen mittens"
    ]

    // Mark: Table View Data Source Methods
    
    /**
    * Number of Rows
    */
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        // TODO: Implement this method to get the correct row count
        
        return favoriteThings.count
    }

    
    /**
    * Cell For Row At Index Path
    */

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      
        // 1. Dequeue a reusable cell from the table, using the correct “reuse identifier”
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        // 2. Find the model object that corresponds to that row
        let favoriteThingForRow = favoriteThings[indexPath.row]
        // 3. Set the images and labels in the cell with the data from the model object
        cell.textLabel?.text = favoriteThingForRow
    
        // 4. return the cell.
        return cell
    }
}

