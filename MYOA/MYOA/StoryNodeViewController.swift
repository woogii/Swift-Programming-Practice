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
    

    // MARK : - Property 
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var restartButton: UIButton!
    
    let cellIdentifier = "promptCell"
    var currentNode:StoryNode!
    
    // MARK : - View Life Cycle

    override func viewWillAppear(animated: Bool) {
        
        imageView.image = UIImage(named: (currentNode.imageName)!)
        storyTextView.text = currentNode.message

        restartButton.hidden = currentNode.promptCount()>0
    }
    
    // MARK : - TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentNode.promptCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        cell.textLabel!.text = currentNode.promptForIndex(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("StoryNodeViewController")
        as! StoryNodeViewController
        
        // Get the next node
        let nextNode = self.currentNode.storyNodeForIndex(indexPath.row)
        controller.currentNode = nextNode
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func restartStory(sender: UIButton){
        let initialController = navigationController?.viewControllers[1]
        navigationController?.popToViewController(initialController!, animated: true)
    }
}