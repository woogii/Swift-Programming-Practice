//
//  ViewController.swift
//  NSNotificationCenter_Sample
//
//  Created by Hyun on 2016. 1. 9..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

let mySpecialNofiticationKey = "com.andrewbancroft.specialNotificationKey"

class FirstViewController: UIViewController {

    @IBOutlet weak var sendNotificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationSentLabel", name: mySpecialNofiticationKey, object: nil)
    }

    

    @IBAction func NotifyButtonClicked(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNofiticationKey, object: self)
    }
    
    func updateNotificationSentLabel(){
        sendNotificationLabel.text = "Notification Sent!"
    }
    
    
}

