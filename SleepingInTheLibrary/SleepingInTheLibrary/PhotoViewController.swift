//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Hyun on 2016. 1. 17..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

let BASE_URL = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.galleries.getPhotos"
let API_KEY = "9a00d835e032b9fe05b30215d22b5713"
let GALLERY_ID = "5704-72157622566655097"
let EXTRAS = "url_m"
let DATA_FORMAT = "json"
let NO_JSON_CALLBACK = "1"


class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        descriptionLabel.text = "Click Grab New Image"
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func grabNewImage(sender: UIButton) {
        
        let methodArguments = [
            "method"  : METHOD_NAME,
            "api_key" : API_KEY,
            "gallery_id" : GALLERY_ID,
            "extras" : EXTRAS,
            "format" : DATA_FORMAT,
            "nojsoncallback" : NO_JSON_CALLBACK
        ]
        
        var parsedResult:AnyObject!
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        print(urlString)
        let url = NSURL(string: urlString)!
        print(url)
        let request = NSURLRequest(URL: url)
        
        
        let task = session.dataTaskWithRequest(request) {
                                    (data, response, error)-> Void  in
            
            guard error == nil else {
                print(error?.description)
                return
            }
            
            guard response != nil else {
                print("Response error")
                return
            }
            
            guard data != nil else {
                print("There is not a data from url request")
                return
            }
            
            do {
                // AllowFragments: Specifies that the parser should allow top-level objects that are not an instance of NSArray or NSDictionary.
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
            } catch _  {
                print(error!.description)
            }
            
            guard let photoInfo = parsedResult.valueForKey("photos") as? NSDictionary else{
                print("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            let photoCount = photoInfo["total"] as! Int
            let randomCount = Int(arc4random_uniform(UInt32(photoCount)))
            
            guard let photoArray = photoInfo["photo"] as? [[String:AnyObject]] else {
                print("Cannot find a key 'photo' in \(parsedResult)")
                return
            }
            
            let photo = photoArray[randomCount] as [String:AnyObject]
            let title = photo["title"] as? String
            
            guard let imageURL = photo["url_m"] as? String else{
                print("Cannot find a key 'url_m' in \(photo)")
                return
            }
            
            let url = NSURL(string: imageURL)
            
            if let data = NSData(contentsOfURL: url!) {
                                    
                dispatch_async(dispatch_get_main_queue()) {
                    self.imageView.image = UIImage(data:data)
                    self.descriptionLabel.text = title
                }
                
            }
                    
        }
        
        task.resume()
    }

    func escapedParameters(parameters: [String:AnyObject])->String {
        
        var urlStrings = [String]()
        
        for (key, value) in parameters {
            
            let stringValue = "\(value)"
            
            let escapedString = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            urlStrings += [key + "=" + "\(escapedString!)"]
        
        }
        
        return (!urlStrings.isEmpty ?  "?" : "") + urlStrings.joinWithSeparator("&")
    }
  
}

