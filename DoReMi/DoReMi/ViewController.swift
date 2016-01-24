//
//  ViewController.swift
//  DoReMi
//
//  Created by Jason Schatz on 11/18/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource {


    let cellReuseIdentifier = "MyCellReuseIdentifier"
    

    
    let model = [
        ["text":"Do" , "detail": "a deer, a female deer"],
        ["text":"Re" , "detail": "a drop of golden sun"],
        ["text":"Mi" , "detail": "a name I call myself"],
        ["text":"Fa" , "detail": "a name I call myself"],
        ["text":"Sol", "detail": "a needle pulling thread"],
        ["text":"La" , "detail": "a note to follow so"],
        ["text":"Ti" , "detail": "a drink with jam and bread"]
    ]
    
    // Add the two essential table data source methods here
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        let item = model[indexPath.row]
        cell.textLabel!.text = item["text"]
        cell.detailTextLabel!.text = item["detail"]
        
        return cell
    }

}

