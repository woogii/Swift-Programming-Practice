//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Hyun on 2016. 1. 17..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    // MARK : - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var grabButton: UIButton!
    
    
    // MARK : - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        descriptionLabel.text = "Click Grab New Image"
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK : - UIButton action method
    
    @IBAction func grabNewImage(sender: UIButton) {
        setUIEnabled(false)
        getImageFromFlick()
      
    }
    
    // MARK : - UIView objects configurations
    func setUIEnabled(enabled: Bool) {
        descriptionLabel.enabled = enabled
        grabButton.enabled = enabled
        
        if enabled {
            grabButton.alpha = 1.0
        } else {
            grabButton.alpha = 0.5
        }
    }
    
    
    // MARK : - Get images from Flick
    
    func getImageFromFlick() {
        
        let methodArguments = [
            Constants.FlickrAPIKeyParams.Method : Constants.FlickrAPIValuesParams.MethodValue,
            Constants.FlickrAPIKeyParams.APIKey : Constants.FlickrAPIValuesParams.APIKeyValue,
            Constants.FlickrAPIKeyParams.GalleryId : Constants.FlickrAPIValuesParams.GallerIdValue,
            Constants.FlickrAPIKeyParams.Extras : Constants.FlickrAPIValuesParams.UrlValue,
            Constants.FlickrAPIKeyParams.Format : Constants.FlickrAPIValuesParams.FormatValue,
            Constants.FlickrAPIKeyParams.NoJSONCallback : Constants.FlickrAPIValuesParams.DisableJSONCallback
        ]
                
        let session = NSURLSession.sharedSession()
        let urlString = Constants.FlickrAPI.BaseURL + escapedParameters(methodArguments)
        

        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        
        let task = session.dataTaskWithRequest(request) { (data, response, error)-> Void  in
            
            // MARK : - Display an error
            func displayError(error: String) {
                print(error)
                print("URL at time of error: \(url)")
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                }
            }
            
            guard error == nil else {
                displayError((error?.description)!)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError((error?.description)!)
                return
            }
            
            guard data != nil else {
                displayError((error?.description)!)
                return
            }
            
            let parsedResult:AnyObject!
            do {
                // AllowFragments: Specifies that the parser should allow top-level objects that are not an instance of NSArray or NSDictionary.
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
            } catch  {
                displayError("\(data)")
                return
            }
            
            guard let photosDictionary = parsedResult[Constants.FlickrAPIResponseKeys.Photos] as? [String:AnyObject],
                photoArray = photosDictionary[Constants.FlickrAPIResponseKeys.Photo] as? [[String:AnyObject]] else {
                    
                displayError((error?.description)!)
                return
            }
            
            // Select a random photo
            let randomIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoDictionary = photoArray[randomIndex] as [String:AnyObject]
            let photoTitle = photoDictionary[Constants.FlickrAPIResponseKeys.Title] as? String
            
            
            guard let imageURLString = photoDictionary[Constants.FlickrAPIResponseKeys.MediumURL] as? String else{
                print("Cannot find a key 'url_m' in \(photoDictionary)")
                return
            }
            
            let imageURL = NSURL(string: imageURLString)
            
            if let data = NSData(contentsOfURL: imageURL!) {
                
                performUIUpdatesOnMain() {
                    self.setUIEnabled(true)
                    self.imageView.image = UIImage(data:data)
                    self.descriptionLabel.text = photoTitle
                }
                
            } else {
                displayError((error?.description)!)
            }
            
        }
        
        task.resume()
    }
    
  

    // MARK : - Transfrom String value into safe ASCII code value
    
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

