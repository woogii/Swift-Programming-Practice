//
//  JSON-Parsing-Achievements-Solution.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

/* Path for JSON files bundled with the Playground */
var pathForAchievementsJSON = NSBundle.mainBundle().pathForResource("achievements", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAchievementsJSON = NSData(contentsOfFile: pathForAchievementsJSON!)

/* Error object */
var parsingAchivementsError: NSError? = nil

/* Parse the data into usable form */
var parsedAchievementsJSON = try! NSJSONSerialization.JSONObjectWithData(rawAchievementsJSON!, options: .AllowFragments) as! NSDictionary


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
    if let achieveInfoDictArray = dictionary["achievements"] as? [[String:AnyObject]] {
        
        for achieveInfo in achieveInfoDictArray {
            print("title: \(achieveInfo["title"]!)")
            print("Description : \(achieveInfo["description"]!)")

            if let imageInfo = achieveInfo["icon"] as? NSDictionary {
            
                if let urlString = imageInfo["url"] as? String {
                    
                    let url = NSURL(string:urlString)!
                    
                    taskForImage(url) {  data, error in
                        
                        if let data = data {
                            _ = UIImage(data: data)
                        }
                        
                    }

                }
            }
        }
        
    }
}

parseJSONAsDictionary(parsedAchievementsJSON)

