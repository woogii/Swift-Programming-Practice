//
//  ThirdViewController.swift
//  NSNotificationCenter_Sample
//
//  Created by Hyun on 2016. 1. 9..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

class ThirdViewController : UIViewController {
    
    @IBOutlet weak var notificationlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "actOnSpecialNotification", name: mySpecialNofiticationKey, object: nil)
    }
    
 
    func actOnSpecialNotification() {
        self.notificationlabel.text = "I heard the notification, too!"
    }
}
