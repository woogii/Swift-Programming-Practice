//
//  ResultViewController.swift
//  Rosambo
//
//  Created by Hyun on 2016. 1. 15..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit


class ResultViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    

    
    var match: RPSMatch!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func playAgainButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
