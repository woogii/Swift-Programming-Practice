//
//  ViewController.swift
//  FlickFinder
//
//  Created by Hyun on 2015. 11. 6..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit

// Define constants
let BASE_URL = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.photos.search"
// Add your API_KEY
let API_KEY = ""
let EXTRAS = "url_m"
let SAFE_SEARCH = "1"
let DATA_FORMAT = "json"
let NO_JSON_CALLBACK = "1"

let BOUNDING_BOX_HALF_WIDTH = 1.0
let BOUNDING_BOX_HALF_HEIGHT = 1.0
let LAT_MIN = -90.0
let LAT_MAX = 90.0
let LON_MIN = -180.0
let LON_MAX = 180.0

class ViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phraseText: UITextField!
    @IBOutlet weak var latitudeText: UITextField!
    @IBOutlet weak var longitudeText: UITextField!
    @IBOutlet weak var phraseSearch: UIButton!
    @IBOutlet weak var locationSearch: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var defaultText: UILabel!
    
    var tapRecognizer:UITapGestureRecognizer? = nil
    
    @IBAction func searchPhotosByLatLonButtonTouchUp(sender: AnyObject) {
    
        if latitudeText.text == ""  || longitudeText.text == "" {
            
            if latitudeText.text == "" && longitudeText.text == "" {
                titleLabel.text = "Latitude and Longitiude value are Empty."
            } else if longitudeText.text == "" {
                titleLabel.text = "Lon Empty."
            } else {
                titleLabel.text = "Lat Empty."
            }
        }
        
        
        if  checkLatitude() && checkLatitude() {

            titleLabel.text = "Searching..."
            
            let methodArguments:[String:String!] = [
                "method": METHOD_NAME,
                "api_key": API_KEY,
                "bbox" :  createBoundingBoxString(),
                "safe_search" : SAFE_SEARCH,
                "extras": EXTRAS,
                "format": DATA_FORMAT,
                "nojsoncallback": NO_JSON_CALLBACK
            ]
            
            getImageFromFlickBySearch(methodArguments)
        }
        else {
            if !checkLatitude()  && !checkLatitude() {
                titleLabel.text = "Each value should be in the range. Latitude:[-180,180], Longitude: [-90,90]."
            } else if !checkLatitude() {
                titleLabel.text = "Latitude Empty."
            } else {
                titleLabel.text = "Longitude Empty."
            }

            return
        }
        
        
    }
    
    func checkLatitude()-> Bool {
        
        if  latitudeText.text != "" {
            let latitudeValue = (latitudeText.text! as NSString).doubleValue
        
            if latitudeValue > LAT_MAX || latitudeValue < LAT_MIN {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func checkLogitude()-> Bool {
        if  latitudeText.text != "" {
            let longitudeValue = (longitudeText.text! as NSString).doubleValue
            
            if longitudeValue > LON_MAX || longitudeValue < LON_MIN {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func createBoundingBoxString()->String {
        let longitude = (longitudeText.text! as NSString).doubleValue
        let latitude  = (latitudeText.text! as NSString).doubleValue
        
        let bottom_left_lon = max(longitude - BOUNDING_BOX_HALF_WIDTH, LON_MIN)
        
        let bottom_left_lat = max(latitude - BOUNDING_BOX_HALF_HEIGHT, LAT_MIN)
        
        let top_right_lon = min(longitude + BOUNDING_BOX_HALF_WIDTH, LON_MAX)
        
        let top_right_lat = min(latitude + BOUNDING_BOX_HALF_HEIGHT, LAT_MAX)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }
    
    @IBAction func searchPhotosByPhraseButtonTouchUp(sender: AnyObject) {
        
        if phraseText.text != "" {
            
            titleLabel.text = "Searching..."
            
            /* Added from student request -- hides keyboard after searching */
            //self.dismissAnyVisibleKeyboards()
            
            let methodArguments:[String:String!] = [
                "method": METHOD_NAME,
                "api_key": API_KEY,
                "text"  : phraseText.text,
                "safe_search" : SAFE_SEARCH,
                "extras": EXTRAS,
                "format": DATA_FORMAT,
                "nojsoncallback": NO_JSON_CALLBACK
            ]
            
            getImageFromFlickBySearch(methodArguments)
            
        } else {
            titleLabel.text = "Phrase Empty..."
        }
        
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated:Bool){
        super.viewWillDisappear(animated)
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        // notification posted immediately prior to the display of the keyboard
        NSNotificationCenter .defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        // notification posted immediately prior to the dismissal of the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // remove all observers from self
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification:NSNotification) {
        if imageView != nil {
            defaultText.alpha = 0.0
        }
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        if imageView != nil {
            defaultText.alpha = 1.0
        }
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification)->CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
    
        return keyboardSize!.height
    }

    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }

    func getImageFromFlickBySearch(methodArguments:[String:AnyObject]) {
        
        
        // Initialize session and rul
        let session = NSURLSession.sharedSession()
        let urlString =  BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string:urlString)!
        let request = NSURLRequest(URL: url)
        
        // Initialize task for getting data
        let task = session.dataTaskWithRequest(request) { (data,response, error) in


            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* Parse the data! */
            let parsedResult: AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)

            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error? */
            guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                print("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
        
            /* GUARD: Is "photos" key in our result? */
            guard let photosDictionary = parsedResult["photos"] as? NSDictionary else {
                print("Cannot find keys 'photos' in \(parsedResult)")
                return
            }
            
            if let totalPages = photosDictionary["pages"] as? Int {
                let page = min(totalPages, 40)
                let randomPage = Int(arc4random_uniform(UInt32(page))+1)
            
                self.getImageFlickBySearchWithPage(randomPage, photosDictionary: photosDictionary)
            }
        }
        task.resume()
    }
    
    
    func getImageFlickBySearchWithPage(randomPage:Int, photosDictionary:NSDictionary) {
        
        guard let photoArray = photosDictionary["photo"] as? [[String:AnyObject]] else {
            print("Cannot find key 'photo' in \(photosDictionary)")
            return
        }
            
        // Grab a single, random image
        let photoDictionary  = photoArray[randomPage] as [String:AnyObject]
        
        // Get the image url and titles
        let photoTitle = photoDictionary["title"] as! String
        let urlString = photoDictionary["url_m"] as! String
            let imageURL = NSURL(string:urlString)!
        
        // if an image exists at the url, set the image and title
        if let imageData = NSData(contentsOfURL: imageURL) {
            dispatch_async(dispatch_get_main_queue(), {
                self.defaultText.alpha = 0.0
                self.imageView.image = UIImage(data: imageData)
                self.titleLabel.text = photoTitle
            })
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
            print("No Photos Found. Search Again.")
                self.defaultText.alpha = 1.0
                self.imageView.image = nil
                self.titleLabel.text = "No photos found. Search again!"
            })
        
        }
    
    }

}


extension ViewController {
    func dismissAnyVisibleKeyboards() {
        if phraseText.isFirstResponder() || latitudeText.isFirstResponder() || longitudeText.isFirstResponder() {
            self.view.endEditing(true)
        }
    }
}

