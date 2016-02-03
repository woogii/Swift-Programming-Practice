//
//  ViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catURL = NSURL(string:Constants.CatURL)!
        let puppyURL = NSURL(string:Constants.PuppyURL)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(puppyURL){
                                                        data,response, error in
            guard let data = data else {
                print(error?.description)
                return;
            }
            
            let image = UIImage(data: data)
            
            performUIUpdatesOnMain() {
                self.imageView.image = image
            }
        }
    
        task.resume()
    
    }
}
