//
//  StoryNodeViewController.swift
//  MYOA
//
//  Created by Hyun on 2016. 1. 29..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

class StoryNodeViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storyTextView: UITextView!
    
    var imageName : String?
    var story: String?
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = UIImage(named: imageName!)
        storyTextView.text = story
    }
    
    let cellIdentifier = "promptCell"
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        return cell
    }
    
}