//
//  HighScoreTableViewController.swift
//  Colour Memory
//
//  Created by TeamSlogup on 2016. 4. 24..
//  Copyright © 2016년 siwook. All rights reserved.
//

import Foundation
import UIKit 


class HighScoreTableViewController : UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    

    
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    

    
}

extension HighScoreTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}