//
//  HighScoreTableViewController.swift
//  Colour Memory
//
//  Created by Hyun on 2016. 4. 24..
//  Copyright © 2016년 siwook. All rights reserved.
//

import Foundation
import UIKit 

// MARK : - HighScoreTableViewController : UIViewController
class HighScoreTableViewController : UIViewController {
    
    // MARK : Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableviewTopConstraint: NSLayoutConstraint!
    
    var highScoreList = [String:Int]()
    var score:Int? = nil
    var rank:Int? = nil
    
    // MARK : Constants 
    struct Constants {
        
        static let HeaderCellIdentifier = "sectionHeader"
        static let CellIdentifier       = "scoreCell"
        static let HeaderFirstColumn    = "RANK"
        static let HeaderSecondColumn   = "NAME"
        static let HeaderThirdColumn    = "SCORE"
        static let RankLabelTag         = 100
        static let NameLabelTag         = 101
        static let ScoreLabelTag        = 102
        static let NumOfHeader          = 1
        static let layoutContraintValue = 109
    }
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
       
        // If there is no score value, which means user did not play game
        guard let score = score else {
            
            // Hide labels
            scoreLabel.hidden = true
            rankLabel.hidden = true
            messageLabel.hidden = true
            
            // Move tableview up
            tableviewTopConstraint.constant = tableviewTopConstraint.constant - CGFloat(Constants.layoutContraintValue)
            
            return
        }
        
        scoreLabel.text = "Your Score : \(score)"
        
        // If there is no rank value
        guard let rank = rank else {
            rankLabel.text = "Your Rank : No Record Found"
            return
        }
        
        // If rank value is set
        if rank != 0  {
            rankLabel.text = "Your Rank : \(rank)"
        }else {
            rankLabel.text = "Your Rank : No Record Found"
        }
        
    }
}

// MARK : - HighScoreTableViewController : UITableViewDelegate, UITableViewDataSource
extension HighScoreTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK : UITableViewDelegate Method
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.HeaderCellIdentifier)
        
        let rankLabel = cell?.viewWithTag(Constants.RankLabelTag) as! UILabel
        rankLabel.text = Constants.HeaderFirstColumn
        
        let nameLabel = cell?.viewWithTag(Constants.NameLabelTag) as! UILabel
        nameLabel.text = Constants.HeaderSecondColumn
  
        let scoreLabel = cell?.viewWithTag(Constants.ScoreLabelTag) as! UILabel
        scoreLabel.text = Constants.HeaderThirdColumn

        return cell
    }
    
    // MARK : UITableViewDataSource Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.NumOfHeader
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScoreList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier, forIndexPath: indexPath) as? ScoreCell
    
        // Sort scores descending and then display scores in order
        let sortedList = highScoreList.sort { $0.1 > $1.1 }
        
        cell?.rankLabel.text = String(indexPath.row+1)
        cell?.nameLabel.text = sortedList[indexPath.row].0
        cell?.scoreLabel.text = String(sortedList[indexPath.row].1)
    
        return cell!
    }
}