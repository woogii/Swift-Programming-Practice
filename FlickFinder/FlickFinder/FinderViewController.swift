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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var photoInfoLabel: UILabel!
    @IBOutlet weak var latLonSearchButton: UIButton!
    
    @IBOutlet weak var phraseSearchButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUIEnabled(enabled:Bool) {
        phraseSearchButton.enabled = enabled
        latLonSearchButton.enabled = enabled
    }

    @IBAction func phraseSearch(sender: AnyObject) {

        setUIEnabled(false)
        displayImageFromFlickr()
    }

    @IBAction func latLonSearch(sender: AnyObject) {
        setUIEnabled(false)
        displayImageFromFlickr()
    }
    
    func displayImageFromFlickr() {
        
        let methodArguments = [
            Constants.FlickrAPIParamKeys.Method:Constants.FlickrAPIParamValues.MethodValue,
            Constants.FlickrAPIParamKeys.APIKey:Constants.FlickrAPIParamValues.APIKeyValue,
           Constants.FlickrAPIParamKeys.Text:phraseTextField.text!,
            
            Constants.FlickrAPIParamKeys.BoundingBox:Constants.FlickrAPIParamValues.BBoxValue,
            
            Constants.FlickrAPIParamKeys.SafeSearch:
                Constants.FlickrAPIParamValues.UseSafeSearch,
            Constants.FlickrAPIParamKeys.Extras:Constants.FlickrAPIParamValues.MediumURL,
            Constants.FlickrAPIParamKeys.Format:Constants.FlickrAPIParamValues.FormatValue,
            Constants.FlickrAPIParamKeys.NoJSONCallback:Constants.FlickrAPIParamValues.DisableJSONCallback
        ]
        
        let session = NSURLSession.sharedSession()
        let urlValue = buildUrlValue(methodArguments)
        
        let httpRequest = NSURLRequest(URL: urlValue)
      
        let task = session.dataTaskWithRequest(httpRequest, completionHandler: {
            (data,response, error) in
        
            
            func displayError(error:String) {
                print(error)
            }
            
            guard error == nil  else {
                displayError((error?.description)!)
                return
            }
            
            guard let data = data else {
                displayError((error?.description)!)
                return
            }
            
            let parsedResult:AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                print(parsedResult)
            } catch  {
               displayError("Parsing error")
            }
            

            
        })
        
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
    
//        urlComponents.queryItems?.append(NSURLQueryItem(name: Constants.FlickrAPIParamKeys.Method, value: Constants.FlickrAPIParamValues.MethodValue))
//        
//        urlComponents.queryItems?.append(NSURLQueryItem(name: Constants.FlickrAPIParamKeys.APIKey, value: Constants.FlickrAPIParamValues.APIKeyValue))
//        
//        urlComponents.queryItems?.append(NSURLQueryItem(name: Constants.FlickrAPIParamKeys.Text, value: Constants.FlickrAPIParamValues.TextValue))
//        
//        urlComponents.queryItems?.append(NSURLQueryItem(name: Constants.FlickrAPIParamKeys.BoundingBox, value: Constants.FlickrAPIParamValues.BBoxValue))
//        
//        urlComponents.queryItems?.append(NSURLQueryItem(name: Constants.FlickrAPIParamKeys.Method, value: Constants.FlickrAPIParamValues.MethodValue))
//        
//        urlComponents.queryItems?.append(NSURLQueryItem(name:Constants.FlickrAPIParamKeys.SafeSearch, value:Constants.FlickrAPIParamValues.UseSafeSearch))
//        
//        urlComponents.queryItems?.append(NSURLQueryItem(name:Constants.FlickrAPIParamKeys.Extras, value:Constants.FlickrAPIParamValues.MediumURL))
//        
//        urlComponents.queryItems?.append(NSURLQueryItem(name: Constants.FlickrAPIParamKeys.Format, value: Constants.FlickrAPIParamValues.FormatValue))
//
//        urlComponents.queryItems?.append(NSURLQueryItem(name:Constants.FlickrAPIParamKeys.NoJSONCallback, value: Constants.FlickrAPIParamValues.DisableJSONCallback))
    
}

