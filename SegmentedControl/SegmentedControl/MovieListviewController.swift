//
//  ViewController.swift
//  SegmentedControl
//
//  Created by Hyun on 2016. 2. 18..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

class MovieListviewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "MovieInfoCell"
    
    let topList =  ["Top 10 most Anticipated Movies of 2016",
                    "12 Hidden Gems Starring The Average Cast",
                    "Moives With Kick-ass Women"
                    ]
    let inTheater = [ "RACE", "RISEN", "WATCH"]
    let upComing = ["River of Grass", "The Dark House", "Invitation"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            count = topList.count
            break
        case 1:
            count = inTheater.count
            break
        case 2:
            count = upComing.count
            break
        default :
            break
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            cell.textLabel!.text = topList[indexPath.row]
            break
        case 1:
            cell.textLabel!.text = inTheater[indexPath.row]
            break
        case 2:
            cell.textLabel!.text = upComing[indexPath.row]
            break
        default :
            break
        }


        
        return cell
    }
    
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
        tableView.reloadData()
    }

}

