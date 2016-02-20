//
//  ViewController.swift
//  GCD_practice
//
//  Created by Hyun on 2016. 2. 20..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

enum BigImages: String{
    case whale = "https://lh3.googleusercontent.com/16zRJrj3ae3G4kCDO9CeTHj_dyhCvQsUDU0VF0nZqHPGueg9A9ykdXTc6ds0TkgoE1eaNW-SLKlVrwDDZPE=s0#w=4800&h=3567"
    case shark = "https://lh3.googleusercontent.com/BCoVLCGTcWErtKbD9Nx7vNKlQ0R3RDsBpOa8iA70mGW2XcC76jKS09pDX_Rad6rjyXQCxngEYi3Sy3uJgd99=s0#w=4713&h=3846"
    case seaLion   = "https://lh3.googleusercontent.com/ibcT9pm_NEdh9jDiKnq0NGuV2yrl5UkVxu-7LbhMjnzhD84mC6hfaNlb-Ht0phXKH4TtLxi12zheyNEezA=s0#w=4626&h=3701"
}

class ViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func simpleAsynchronousDownload(sender: UIBarButtonItem) {
        print("test")
        
        guard let url = NSURL(string:String(BigImages.whale.rawValue)) else {
            print("Cannot get url")
            return
        }
        
        let download = dispatch_queue_create("download", nil)
        
        dispatch_async(download) { () -> Void in
            
            guard let data = NSData(contentsOfURL: url) else {
                print("Cannot get data")
                return
            }
            
            let image = UIImage(data: data)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.photoView.image = image
            }
        }
        

        
    }
  
    
    @IBAction func synchronousDownload(sender: UIBarButtonItem) {
        
        guard let url = NSURL(string:String(BigImages.whale.rawValue)) else {
            print("Cannot get url")
            return
        }
        
        guard let data = NSData(contentsOfURL: url) else {
            print("Cannot get data")
            return
        }
        
        let image = UIImage(data: data)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.photoView.image = image
        }
    }

    @IBAction func setTransparencyOfImage(sender: UISlider) {
        
        
        
    }
    
    @IBAction func asynchronousDownload(sender: UIBarButtonItem) {
    }
    
}

