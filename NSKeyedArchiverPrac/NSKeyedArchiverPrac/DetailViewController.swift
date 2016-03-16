//
//  DetailViewController.swift
//  NSKeyedArchiverPrac
//
//  Created by Hyun on 2015. 12. 1..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: AnyObject? {
        
        didSet {
            // Update the view.
            print("in didSet")
            self.configureView()
        }
    }
    
    //var detailItem:AnyObject?
    
    func configureView() {
        print("in configure view")
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                print("set text")
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

