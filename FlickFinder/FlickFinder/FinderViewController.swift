//
//  ViewController.swift
//  FlickFinder
//
//  Created by Hyun on 2016. 2. 4..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit
import Foundation

class FinderViewController: UIViewController {

    // MARK : - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var photoInfoLabel: UILabel!
    @IBOutlet weak var latLonSearchButton: UIButton!
    @IBOutlet weak var phraseSearchButton: UIButton!
    
    // MARK : - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phraseTextField.delegate = self
        longitudeTextField.delegate = self
        latitudeTextField.delegate = self
        
        // Add tap gesture to dismiss keyboard when a user touches the screen
        let tapGesture: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapGesture)
        
        // Adds an entry to the receiver's dispatch table
        subscribeNotification(Selector(stringLiteral: "keyBoardWillShow:"), notification: UIKeyboardWillShowNotification)
        subscribeNotification(Selector(stringLiteral: "keyBoardWillHide:"), notification: UIKeyboardWillHideNotification)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Removes matching entries from the receiver's dispatch table
        unsubscribeNotification(UIKeyboardWillShowNotification)
        unsubscribeNotification(UIKeyboardWillHideNotification)
    }
    
    @IBAction func phraseSearch(sender: AnyObject) {
        setUIEnabled(false)
        
        if !phraseTextField.text!.isEmpty {
            photoInfoLabel.text = "Searching..."
            searchImagesByPhrase()
        } else {
            setUIEnabled(true)
            photoInfoLabel.text = "Phrase Empty."
        }
    }

    @IBAction func latLonSearch(sender: AnyObject) {
        
        setUIEnabled(false)
        
        if isTextFieldValid(latitudeTextField, forRange: Constants.FlickrAPI.SearchLatRange) &&
            isTextFieldValid(longitudeTextField, forRange: Constants.FlickrAPI.SearchLonRange ) {
            photoInfoLabel.text = "Searching..."
            searchImagesByLatLon()
            
        } else {
            setUIEnabled(true)
            photoInfoLabel.text = "Latitude should be [-90.0, 90.0]\n\n Longitude should be [-180,180]"
        }
    }
    
    func getBBoxValue()->String {
        
        if let latitude = Double(latitudeTextField.text!), let longitude = Double(longitudeTextField.text!) {
        
            let min_lon = max(longitude - Constants.FlickrAPI.SearchBBoxHalfHeight, Constants.FlickrAPI.SearchLonRange.0)
            let min_lat = max(latitude - Constants.FlickrAPI.SearchBBoxHalfWidth, Constants.FlickrAPI.SearchLatRange.0)
            let max_lon = min(longitude + Constants.FlickrAPI.SearchBBoxHalfHeight, Constants.FlickrAPI.SearchLonRange.1)
            let max_lat = min(latitude + Constants.FlickrAPI.SearchBBoxHalfWidth, Constants.FlickrAPI.SearchLatRange.1)
        
            return "\(min_lon),\(min_lat),\(max_lon),\(max_lat)"
        } else {
            return "0,0,0,0"
        }
        
    }
    
    func searchImagesByPhrase() {
        
        let methodArguments = [
            Constants.FlickrAPIParamKeys.Method:Constants.FlickrAPIParamValues.MethodValue,
            Constants.FlickrAPIParamKeys.APIKey:Constants.FlickrAPIParamValues.APIKeyValue,
            Constants.FlickrAPIParamKeys.Text:phraseTextField.text!,
            Constants.FlickrAPIParamKeys.SafeSearch:Constants.FlickrAPIParamValues.UseSafeSearch,
            Constants.FlickrAPIParamKeys.Extras:Constants.FlickrAPIParamValues.MediumURL,
            Constants.FlickrAPIParamKeys.Format:Constants.FlickrAPIParamValues.FormatValue,
            Constants.FlickrAPIParamKeys.NoJSONCallback:Constants.FlickrAPIParamValues.DisableJSONCallback
        ]
        
        getSearchPageFromFlickr(methodArguments)
    }
    
    func searchImagesByLatLon() {
        let methodArguments = [
            Constants.FlickrAPIParamKeys.Method:Constants.FlickrAPIParamValues.MethodValue,
            Constants.FlickrAPIParamKeys.APIKey:Constants.FlickrAPIParamValues.APIKeyValue,
            Constants.FlickrAPIParamKeys.Text:phraseTextField.text!,
            Constants.FlickrAPIParamKeys.BoundingBox: getBBoxValue(),
            Constants.FlickrAPIParamKeys.SafeSearch:Constants.FlickrAPIParamValues.UseSafeSearch,
            Constants.FlickrAPIParamKeys.Extras:Constants.FlickrAPIParamValues.MediumURL,
            Constants.FlickrAPIParamKeys.Format:Constants.FlickrAPIParamValues.FormatValue,
            Constants.FlickrAPIParamKeys.NoJSONCallback:Constants.FlickrAPIParamValues.DisableJSONCallback
        ]

        getSearchPageFromFlickr(methodArguments)
    }

    
    func getSearchPageFromFlickr(methodArguments:[String:String]) {
        
        var randomPage = 0
        
        // create session and request
        let session = NSURLSession.sharedSession()
        let httpRequest = NSURLRequest(URL: buildUrlValue(methodArguments))
      
        // create network request
        let task = session.dataTaskWithRequest(httpRequest, completionHandler: {
            (data,response, error) in
        
            // if an error occurs, print it and re-enable the UI
            func displayError(error:String) {
                perfromUIUpdatesOnMain() {
                    self.setUIEnabled(true)
                    self.photoInfoLabel.text = "No photo returned. Try again"
                    self.imageView = nil
                }
                print(error)
            }
            
            // GUARD : Was there an error?
            guard error == nil   else {
                displayError("There was an error with your request : \(error)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200  && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            // GUARD: Was there any data returned?
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult:AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                displayError("Could not parse the data as JSON : '\(data)'")
                return
            }
            
            // GUARD : Did Flickr return an error (stat != ok )?
            guard let stat = parsedResult[Constants.FlickrAPIResponseKeys.Status] as? String where stat == Constants.FlickrAPIResponseValues.OKStatus else {
                displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            // GUARD : Is "photos" key in our result?
            guard let photosDictionary = parsedResult[Constants.FlickrAPIResponseKeys.Photos] as? NSDictionary else {
                displayError("Could not parse the data as JSON : \(data)")
                return
            }
            
            // GUARD : Is "pages" key in the photoDictionary?
            guard let pages = photosDictionary[Constants.FlickrAPIResponseKeys.Pages] as? Int else {
                displayError("Cannot parse JSON object by using subscript \"pages\"")
                return
            }
                
            // Pick a random page
                
            // The maximum number of pics and the total number of pages returned by Flickr API are 4000 and
            // 100, respectively. Therefore, the number of maximum page is going to be 40(4000/100).
            let pageLimit = min(pages, 40)
            randomPage = Int(arc4random_uniform(UInt32(pageLimit)))+1
            
            self.getImagesFromFlickr(methodArguments, searchPage: randomPage)
        })
        
        task.resume()
    }
    
    func getImagesFromFlickr(var methodArguments:[String:AnyObject], searchPage:Int) {
        
        // add the page to the method's parameters
        methodArguments[Constants.FlickrAPIParamKeys.Page] = searchPage
        
        // create session and request
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: buildUrlValue(methodArguments))
        
        // create network request
        let task = session.dataTaskWithRequest(request) {  (data, response, error)-> Void in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(error:String) {
                print(error)
                perfromUIUpdatesOnMain() {
                    self.setUIEnabled(true)
                    self.photoInfoLabel.text = "No photo returned. Try again."
                    self.imageView.image = nil
                }
            }
            
            // GUARD: Was there an error?
            guard error == nil else {
                displayError("There was an error with your request : \(error)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD : Was there any data returned? 
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult:AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)

            } catch {
                displayError("Could not parse the data as JSON : '\(data)'")
                return
            }
            
            // GUARD : Did Flickr return an error (stat != ok)?
            guard let stat = parsedResult[Constants.FlickrAPIResponseKeys.Status] as? String where stat == Constants.FlickrAPIResponseValues.OKStatus else {
                displayError("Flick API returned an error. See error code and message in \(parsedResult)")
                return
            }

            // GUARD: Is the "photos" key in our result?
            guard let photosDictionary = parsedResult[Constants.FlickrAPIResponseKeys.Photos] as? NSDictionary else {
                displayError("Cannot find key '\(Constants.FlickrAPIResponseKeys.Photos)' in \(parsedResult)")
                return
            }
            
            // GUARD: Is the "photo" key in photosDictionary
            guard let photoDictArray = photosDictionary[Constants.FlickrAPIResponseKeys.Photo] as? [[String:AnyObject]] else {
                displayError("Cannot find key '\(Constants.FlickrAPIResponseKeys.Photo)' in \(photosDictionary)")
                return
            }
                
            if photoDictArray.count == 0 {
                displayError("No Photos Found. Search Again.")
                return
            } else {
                
                let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoDictArray.count)))
                let photoDict = photoDictArray[randomPhotoIndex] as [String:AnyObject]
                let photoTitle = photoDict[Constants.FlickrAPIResponseKeys.Title] as? String
                
                // GUARD: Does our photo have a key for 'url_m'?
                guard let urlString = photoDict[Constants.FlickrAPIResponseKeys.MediumURL] as? String else{
                    displayError("Cannot find key '\(Constants.FlickrAPIResponseKeys.MediumURL)' in \(photoDict)")
                    return
                }
                
                // if an image exists at the url, set the image and title
                let imageURL = NSURL(string: urlString)!
                if let imageData = NSData(contentsOfURL: imageURL) {
                    perfromUIUpdatesOnMain() {
                        self.imageView.image = UIImage(data: imageData)
                        self.photoInfoLabel.text = photoTitle ?? "(Untitled)"
                        self.setUIEnabled(true)
                    }
                } else {
                    displayError("Image does not exist at \(imageURL)")
                }
            }
        }
        
        // start the task
        task.resume()
    }

    
    // MARK : Helper method for building a URL
    func buildUrlValue(queryValuePairs:[String:AnyObject])->NSURL{
        
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Constants.FlickrAPI.APIScheme
        urlComponents.host =  Constants.FlickrAPI.APIHost
        urlComponents.path =  Constants.FlickrAPI.APIPath
        urlComponents.queryItems = [NSURLQueryItem]()
        
        for (key, value) in queryValuePairs {
            urlComponents.queryItems?.append(NSURLQueryItem(name: key, value: "\(value)"))
        }
        
        return urlComponents.URL!
    }
    
}

// MARK : - FinderViewController : UITextFieldDelegate 

extension FinderViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
    /// Dismiss keyboard on the screen by removing first responder status
    
    func dismissKeyboard() {
        // Causes the view to resign the first responder status
        view.endEditing(true)
    }
    
    /// UIKeyboardWillShowNotification message is posted immediately prior to the dismissal of the keyboard.
    /// - parameter notification : NSNotification type variable that contains notification information
    
    func keyBoardWillShow(notification: NSNotification) {
        
        // UIKeyboardFrameBeginUserInfoKey
        // The key for an NSValue object containing a CGRect that identifies the start frame of the keyboard in screen coordinates.
        if let userInfo = notification.userInfo {
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    
    /// UIKeyboardWillHideNotification message is posted after the display of the keyboard
    /// - parameter notification : NSNotification type variable that contains notification information
    func keyBoardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    private func isTextFieldValid(textField: UITextField, forRange : (Double, Double)) -> Bool {
        
        if let value = Double(textField.text!) where !textField.text!.isEmpty {
            return isValueInRange(value, min: forRange.0, max: forRange.1)
        } else {
            return false
        }
    }
    
    private func isValueInRange(value:Double, min: Double, max: Double) -> Bool {
        return !(value < min || value > max)
    }
    
}

// MARK : - FinderViewController (Configure UI)

extension FinderViewController {
    
    private func setUIEnabled(enabled: Bool){
    
        phraseTextField.enabled = enabled
        latitudeTextField.enabled = enabled
        longitudeTextField.enabled = enabled
        
        latLonSearchButton.enabled = enabled
        phraseSearchButton.enabled = enabled
        
        if enabled {
            phraseSearchButton.alpha = 1.0
            latLonSearchButton.alpha = 1.0
        } else {
            phraseSearchButton.alpha = 0.5
            latLonSearchButton.alpha = 0.5
        }
    }
}

// MARK : - FinderViewController (Add and remove an entry to the receiver's dispatch table)

extension FinderViewController  {
    
    private func subscribeNotification(selector: Selector, notification : String ) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification , object: nil)
    }
    
    private func unsubscribeNotification(notification:String) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: notification, object: nil)
    }
}

