//
//  JSON-Parsing-Animals-Solution.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

/* Path for JSON files bundled with the Playground */
var pathForAnimalsJSON = NSBundle.mainBundle().pathForResource("animals", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAnimalsJSON = NSData(contentsOfFile: pathForAnimalsJSON!)

/* Error object */
var parsingAnimalsError: NSError? = nil

///* Parse the data into usable form */
var parsedAnimalsJSON = try NSJSONSerialization.JSONObjectWithData(rawAnimalsJSON!, options: .AllowFragments) as! NSDictionary

func taskForImage(url:NSURL, completionHandler : (imageData:NSData?, error:NSError?)->Void) {
    let session = NSURLSession.sharedSession()
    
    
    let task = session.dataTaskWithURL(url) { (data, response, error) in
        
        if let error = error {
            completionHandler(imageData: data, error : error)
        } else {
            completionHandler(imageData: nil,  error:  error)
        }
    }
    task.resume()
    
}


func parseJSONAsDictionary(dictionary: NSDictionary) {
    /* Start playing with JSON here... */

    if let dictionary = dictionary["photos"] as? NSDictionary {
        // print(dictionary)
        
        if let animalDictArray = dictionary["photo"] as? [[String:AnyObject]] {
            // print(animalDictArray)
            
            for animalDictionary:[String:AnyObject] in animalDictArray {
                
                if let id = animalDictionary["id"] as? String {
                    print(id)
                }
           
                if let title = animalDictionary["title"] as? String {
                    print(title)
                }
                
                if let urlString = animalDictionary["url_m"] as? String {
                    print(urlString)
                    let url = NSURL(string:urlString)!
                    
                    taskForImage(url) {  data, error in
                        
                        if let data = data {
                            _ = UIImage(data: data)
                        }
                    }
                }
                
                if let comment = animalDictionary["comment"] as? NSDictionary {
                    
                    if let quot = comment["quot"] as? String {
                        print(quot)
                    }
                }
                
            }
        }
    }

}

parseJSONAsDictionary(parsedAnimalsJSON)
