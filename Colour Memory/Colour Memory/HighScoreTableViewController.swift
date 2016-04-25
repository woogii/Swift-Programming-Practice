//
//  HighScoreTableViewController.swift
//  Colour Memory
//
//  Created by TeamSlogup on 2016. 4. 24..
//  Copyright © 2016년 siwook. All rights reserved.
//

import Foundation
import UIKit 

// MARK : - HighScoreTableViewController : UIViewController
class HighScoreTableViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    var highScoreList: [String:Int]!
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // EDIT:  I updated this code to use a single textView for your high score list
    // buttons, labels, and all the stuff that makes this view work, blah blah blah
    func displayHighScoreList() {
        
        for (user,score) in self.highScoreList {
            
            // write some code here: you may want to count and only display the top 10 users and scores
            
            // add value to textView with a hard return for next line
            // self.highScoreTextView.text? += "\(user): \(score)/r/r"
            
        }
    }

    
}

// MARK : - HighScoreTableViewController : UITableViewDelegate, UITableViewDataSource
extension HighScoreTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}