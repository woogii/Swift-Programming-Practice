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
    
    // var highScoreList = [String:AnyObject]()
    var highScoreList = [ScoreList]()
    
    var score:Int? = nil
    var rank:Int? = nil
    
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
        
        scoreLabel.text = Constants.ResultScoreText + String(score)
        
        // If there is no rank value
        guard let rank = rank else {
            rankLabel.text = Constants.ResultNoRankText
            return
        }
        
        // If rank value is set
        if rank != 0  {
            rankLabel.text = Constants.ResultRankText + String(rank)
        }else {
            rankLabel.text = Constants.ResultNoRankText
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
        
        highScoreList.sortInPlace({$0.score as Int > $1.score as Int})
        
        cell?.rankLabel.text = String(indexPath.row+1)
        cell?.nameLabel.text = highScoreList[indexPath.row].name
        cell?.scoreLabel.text = String(highScoreList[indexPath.row].score as Int)
    
        return cell!
    }
}