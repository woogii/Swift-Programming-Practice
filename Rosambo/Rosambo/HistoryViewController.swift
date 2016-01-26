//
//  HistoryViewController.swift
//  Rosambo
//
//  Created by Hyun on 2016. 1. 25..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "historyCell"
    var history = [RPSMatch]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let match = history[indexPath.row]
        
        let matchResult  =  getMatchResult(match)
        let matchHistory =  getMatchHistory(match)
        
        cell.textLabel!.text = matchResult
        cell.detailTextLabel!.text = matchHistory
        
        return cell
    }
    
    func getMatchResult(match:RPSMatch)->String {
        
        if match.p1 == match.p2  {
            return  ("tie.")
        } else {
            return match.p1.defeats(match.p2) ? ("Win!") :  ("Loss.")
        }
    }
    
    func getMatchHistory(match:RPSMatch)->String {
        return match.p1.description + " vs." + match.p2.description
    }
    
    @IBAction func backToMain(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}