//
//  ViewController.swift
//  ConcurrencyDemo
//
//  Created by Hossam Ghareeb on 11/15/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import UIKit

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://algoos.com/wp-content/uploads/2015/08/ireland-02.jpg", "http://bdo.se/wp-content/uploads/2014/01/Stockholm1.jpg"]

class Downloader {
    
    class func downloadImageWithURL(url:String) -> UIImage! {
        
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        return UIImage(data: data!)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    var queue = NSOperationQueue()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didClickOnStart(sender: AnyObject) {
        
        queue = NSOperationQueue()
        
        let operation1 = NSBlockOperation(block: {

            let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView1.image = img1
            })
            
        })
        
        operation1.completionBlock = {
            print("Operation 1 completed, cancelled:\(operation1.cancelled)")
        }
        queue.addOperation(operation1)
        
        let operation2 = NSBlockOperation(block: {
            
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView2.image = img2
            })
            
        })
        
        operation2.addDependency(operation1)
        operation2.completionBlock = {
            print("Operation 2 completed, cancelled:\(operation2.cancelled)")
        }
        queue.addOperation(operation2)
        
        
        let operation3 = NSBlockOperation(block: {
            
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView3.image = img3
            })
            
        })
        operation3.addDependency(operation2)
        
        operation3.completionBlock = {
            print("Operation 3 completed, cancelled:\(operation3.cancelled)")
        }
        queue.addOperation(operation3)
        
        
        
        let operation4 = NSBlockOperation(block: {
            
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView4.image = img4
            })
            
        })
        
        operation4.completionBlock = {
            print("Operation 4 completed, cancelled:\(operation4.cancelled)")
        }
        
        queue.addOperation(operation4)
        
        
        
        
        #if false
        
        // MARK : - Usage of the NSOperationQueue

        queue.addOperationWithBlock { ()-> Void in
            
            let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView1.image = img1
            })
        }

        queue.addOperationWithBlock { ()-> Void in
            
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView2.image = img2
            })
        }

        queue.addOperationWithBlock { ()-> Void in
            
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView3.image = img3
            })
        }

        queue.addOperationWithBlock { ()-> Void in
            
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView4.image = img4
            })
        }
 
        #endif
        
    
        #if false
        // MARK : - Usage of the Concurrent Dispatch Queue
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue){ () -> Void in
            
            let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView1.image = img1
            })
        }
        
        dispatch_async(queue) { () -> Void in
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView2.image = img2
            })
        }
        
        dispatch_async(queue) { () -> Void in
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView3.image = img3
            })
        }

        dispatch_async(queue) { () -> Void in
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView4.image = img4
            })
        }
        #endif
        
        #if false
        // MARK : - Usage of the Serial Dispatch Queue
        let serialQueue = dispatch_queue_create("com.appcoda.imageQueue", DISPATCH_QUEUE_SERIAL)
        
        dispatch_async(serialQueue) {
            let img1 = Downloader.downloadImageWithURL(imageURLs[0])

            dispatch_async(dispatch_get_main_queue(), {
                self.imageView1.image = img1
            })
        }
        
        dispatch_async(serialQueue) {
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView2.image = img2
            })
        }

        dispatch_async(serialQueue) {
            
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView3.image = img3
            })
            
        }

        dispatch_async(serialQueue) {
            
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView4.image = img4
            })
            
        }
        #endif

        
        //let img1 = Downloader.downloadImageWithURL(imageURLs[0])
        //self.imageView1.image = img1
        
//        let img2 = Downloader.downloadImageWithURL(imageURLs[1])
//        self.imageView2.image = img2
        
//        let img3 = Downloader.downloadImageWithURL(imageURLs[2])
//        self.imageView3.image = img3
        
//        let img4 = Downloader.downloadImageWithURL(imageURLs[3])
//        self.imageView4.image = img4
        
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        self.sliderValueLabel.text = "\(sender.value * 100.0)"
    }
    
    @IBAction func didClickOnCancel(sender: AnyObject) {
        
        self.queue.cancelAllOperations()
    }
    

}

