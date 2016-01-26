//
//  VillainDetailViewController.swift
//  BondVillains
//
//  Created by Hyun on 2016. 1. 26..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

class VillainDetailViewController : UIViewController {
    
    
    @IBOutlet weak var villainImage: UIImageView!
    @IBOutlet weak var villainName: UILabel!
    
    var selectedVillain : Villain!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        villainImage.image = UIImage(named: selectedVillain.imageName)
        villainName.text = selectedVillain.name
    }
    
}