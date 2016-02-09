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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillShow:", name: UIKeyboardWillShowNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        // Removes matching entries from the receiver's dispatch table
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func dismissKeyboard() {
        // Causes the view to resign the first responder status
        view.endEditing(true)
    }
    
    // UIKeyboardWillShowNotification message is posted immediately prior to the dismissal of the keyboard.
    func keyBoardWillShow(notification: NSNotification) {
        
        // UIKeyboardFrameBeginUserInfoKey
        // The key for an NSValue object containing a CGRect that identifies the start frame of the keyboard in screen coordinates.
        if let userInfo = notification.userInfo {
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    
    // UIKeyboardWillHideNotification message is posted after the display of the keyboard
    func keyBoardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func setUIEnabled(enabled:Bool) {
        phraseSearchButton.enabled = enabled
        latLonSearchButton.enabled = enabled
    }

    @IBAction func phraseSearch(sender: AnyObject) {
        setUIEnabled(false)
        searchImagesByPhrase()
        setUIEnabled(true)
    }

    @IBAction func latLonSearch(sender: AnyObject) {
        
        setUIEnabled(false)
        let isProperValue = checkLatLonValue()
        
        if isProperValue {
            searchImagesByLatLon()
        }
        setUIEnabled(true)
    }
    
    func checkLatLonValue()->Bool{
        
        let latitude = Double(latitudeTextField.text!)
        let longitude = Double(longitudeTextField.text!)
        print(latitude)
        print(longitude)
        
        if latitude < Constants.FlickrAPI.SearchLatRange.0 &&  latitude > Constants.FlickrAPI.SearchLatRange.1 {
            photoInfoLabel.text = "Latitude should be [-90.0, 90.0]\n\n Longitude should be [-180,180]"
            return false
        }
        
        if longitude < Constants.FlickrAPI.SearchLonRange.0 && longitude > Constants.FlickrAPI.SearchLonRange.1 {
            photoInfoLabel.text = "Latitude should be [-90.0, 90.0]\n\n Longitude should be [-180,180]"
            return false
        }
        return true
    }
    
    func getBBoxValue()->String {
        
        let latitude = Double(latitudeTextField.text!)
        let longitude = Double(longitudeTextField.text!)
        
        let min_lon = max(longitude! - Constants.FlickrAPI.SearchBBoxHalfHeight, Constants.FlickrAPI.SearchLonRange.0)
        let min_lat = max(latitude! - Constants.FlickrAPI.SearchBBoxHalfWidth, Constants.FlickrAPI.SearchLatRange.0)
        let max_lon = min(longitude! + Constants.FlickrAPI.SearchBBoxHalfHeight, Constants.FlickrAPI.SearchLonRange.1)
        let max_lat = min(latitude! + Constants.FlickrAPI.SearchBBoxHalfWidth, Constants.FlickrAPI.SearchLatRange.1)
        
        return "\(min_lon),\(min_lat),\(max_lon),\(max_lat)"
        
    }
    
    func searchImagesByPhrase() {
        
        let methodArguments = [
            Constants.FlickrAPIParamKeys.Method:Constants.FlickrAPIParamValues.MethodValue,
            Constants.FlickrAPIParamKeys.APIKey:Constants.FlickrAPIParamValues.APIKeyValue,
            Constants.FlickrAPIParamKeys.Text:phraseTextField.text!,
            Constants.FlickrAPIParamKeys.SafeSearch:Constants.FlickrAPIParamValues.UseSafeSearch,
            Constants.FlickrAPIParamKeys.Extras:Constants.FlickrAPIParamValues.MediumURL,
            Constants.FlickrAPIParamKeys.Format:Constants.FlickrAPIParamValues.FormatValue,
            Constants.FlickrAPIParamKeys.NoJSONCallback:Constants.FlickrAPIParamValues.DisableJSONCallback,
            Constants.FlickrAPIParamKeys.Page: Constants.FlickrAPIParamValues.searchPage
        ]
        
        getSearchPageFromFlickr(methodArguments)
        // getImagesFromFlickr(methodArguments, searchPage: searchPage)
        
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
            Constants.FlickrAPIParamKeys.NoJSONCallback:Constants.FlickrAPIParamValues.DisableJSONCallback,
            Constants.FlickrAPIParamKeys.Page: Constants.FlickrAPIParamValues.searchPage
        ]

        getSearchPageFromFlickr(methodArguments)
        // getImagesFromFlickr(methodArguments, searchPage: searchPage)
    }

    
    func getSearchPageFromFlickr(methodArguments:[String:String]) {
        
        var randomPage = 0
        let session = NSURLSession.sharedSession()
        let urlValue = buildUrlValue(methodArguments)
        
        let httpRequest = NSURLRequest(URL: urlValue)
      
        let task = session.dataTaskWithRequest(httpRequest, completionHandler: {
            (data,response, error) in
        
            
            func displayError(error:String) {
                print(error)
            }
            
            // Check whether an error exists
            guard error == nil   else {
                displayError((error?.description)!)
                return
            }
            
            // Check whether http response code is between 200 and 299
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200  && statusCode <= 299 else {
                displayError("http response code is not in a range between 200 and 299")
                return
            }
            // Check whether data exists
            guard let data = data else {
                displayError((error?.description)!)
                return
            }
            
            let parsedResult:AnyObject!
            do {
            
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                // print(parsedResult)
            
                guard let photosDictionary = parsedResult["photos"] as? NSDictionary else {
                    print("Cannot parse JSON object by using subscript \"photos\"")
                    return
                }
                
                guard let pages = photosDictionary["pages"] as? Int else {
                    print("Cannot parse JSON object by using subscript \"pages\"")
                    return
                }
                
                print("pages: \(pages)")
                
                let pageLimit = min(pages, 40)
                randomPage = Int(arc4random_uniform(UInt32(pageLimit)))+1
                
                self.getImagesFromFlickr(methodArguments, searchPage: randomPage)
                
            } catch let error as NSError{
               displayError((error.description))
            }
        })
        
        task.resume()
    }
    
    func getImagesFromFlickr(var methodArguments:[String:String], searchPage:Int) {
        
        print("searchPage : \(searchPage)")
        
        methodArguments[Constants.FlickrAPIParamKeys.Page] = "\(searchPage)"
        
        let session = NSURLSession.sharedSession()
        
        let url = buildUrlValue(methodArguments)
        let request = NSURLRequest(URL: url)
        
        
        let task = session.dataTaskWithRequest(request) {  (data, response, error)-> Void in
            
            func displayError(error:String) {
                print(error)
            }
            
            guard error == nil else {
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("http response code is not in a range between 200 and 299")
                return
            }
            
            guard let data = data else {
                displayError("Cannot receive data from Server")
                return
            }
            
            let parsedResult:AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                print(parsedResult)
                
                guard let photosDictionary = parsedResult["photos"] as? NSDictionary else {
                    print("Cannot parse JSON object by using subscript \"photos\"")
                    return
                }
                
                guard let photoDictArray = photosDictionary["photo"] as? [[String:AnyObject]], let photoCount = photosDictionary["perpage"] as? Int else {
                    print("Cannot parse JSON object by using subscript \"photos\"")
                    return
                }
                
                let randomPage = Int(arc4random_uniform(UInt32(photoCount)))
                
                guard let photoDict = photoDictArray[randomPage] as? [String:AnyObject] else {
                    return
                }
                
                guard let urlString = photoDict[Constants.FlickrAPIParamValues.MediumURL] as? String else {
                    return
                }
                
                let url = NSURL(string: urlString)!
                let data = NSData(contentsOfURL: url)
                
                perfromUIUpdatesOnMain() {
                    self.imageView.image = UIImage(data: data!)
                }

        
            } catch let error as NSError {
                displayError((error.description))
            }
            
        }
        task.resume()
    }

    
    func buildUrlValue(queryValuePairs:[String:String])->NSURL{
        
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Constants.FlickrAPI.APIScheme
        urlComponents.host =  Constants.FlickrAPI.APIHost
        urlComponents.path =  Constants.FlickrAPI.APIPath
        
        urlComponents.queryItems = [NSURLQueryItem]()
        
        for (key, value) in queryValuePairs {
            urlComponents.queryItems?.append(NSURLQueryItem(name: key, value: value))
        }
        
        return urlComponents.URL!
    }
    
}

extension FinderViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
