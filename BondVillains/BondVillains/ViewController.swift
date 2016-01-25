//
//  ViewController.swift
//  BondVillains
//
//  Created by Hyun on 2016. 1. 25..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var villainArray = [Villain]()
    let cellIdentifier = "villainCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        villainArray = Villain.allVillain
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return villainArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let villain = villainArray[indexPath.row]
        
        cell.textLabel!.text = villain.name
        cell.imageView?.image = UIImage(named: villain.imageName)
        cell.detailTextLabel!.text = villain.evilScheme
        
        return cell
    }

}

