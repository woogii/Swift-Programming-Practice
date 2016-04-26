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
    
    var highScoreList = [String:Int]()
    var score:Int? = nil
    var rank:Int?  = nil
    
   
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let nib:UINib = UINib(nibName: "ScoreTableHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "ScoreTableHeader")
    }
    
    override func  viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        tableView.frame = CGRectMake(0,0,CGRectGetWidth(self.view.frame),300);
    }

    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        print(score)
        
        guard let score = score else {
            scoreLabel.hidden = true
            rankLabel.hidden = true
            messageLabel.hidden = true
            
            // tableview.view.frame =  CGRectMake(tableview.view.frame.origin.x, tableview.view.frame.origin.y + yOffset, tableview.view.frame.size.width, tableview.view.frame.size.height);
            // tableView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height)
            // tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
            
            // var frame = tableView.frame
            // frame.origin.y -= 40
            // tableView.frame = frame
            // tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
            
            return
        }
        
        scoreLabel.text = "Your Score : \(score)"
        
        guard let rank = rank else {
            rankLabel.text = "Your Rank : No Data"
            return
        }
        rankLabel.text = "Your Rank : \(rank)"
    }
}

// MARK : - HighScoreTableViewController : UITableViewDelegate, UITableViewDataSource
extension HighScoreTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // header height
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    // header view
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // let header :ScoreTableHeader = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("ScoreTableHeader") as! ScoreTableHeader
        //header.headerView.frame.size = CGRectMake(0, 0, tableView.frame.size.width, 44).size
        // Dequeue with the reuse identifier
        let cell = tableView.dequeueReusableCellWithIdentifier("sectionHeader")
        

        let rankLabel = cell?.viewWithTag(100) as! UILabel
        rankLabel.text = "RANK"
        
        let nameLabel = cell?.viewWithTag(101) as! UILabel
        nameLabel.text = "NAME"
  
        let scoreLabel = cell?.viewWithTag(102) as! UILabel
        scoreLabel.text = "SCORE"

        
        return cell
    }
    
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let headerView = NSBundle.mainBundle().loadNibNamed("ScoreTableHeader", owner: nil, options: nil).first as? ScoreTableHeader else {
//            return nil
//        }
//        
//        // configure header as normal
//        headerView.backgroundColor = UIColor.redColor()
//        headerView.rankLabel.textColor = UIColor.whiteColor()
//        headerView.rankLabel.text = "Hello"
//        
//        return headerView
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScoreList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("scoreCell", forIndexPath: indexPath) as? ScoreCell
    
        let sortedList = highScoreList.sort { $0.1 > $1.1 }
        cell?.rankLabel.text = String(indexPath.row+1)
        cell?.nameLabel.text = sortedList[indexPath.row].0
        
        cell?.scoreLabel.text = String(sortedList[indexPath.row].1)
    
        return cell!
    }
}