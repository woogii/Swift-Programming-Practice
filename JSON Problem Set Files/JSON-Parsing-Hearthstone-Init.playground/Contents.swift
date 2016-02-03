//
//  JSON-Parsing-Hearthstone-Solution.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
let pathForHearthstone = NSBundle.mainBundle().pathForResource("hearthstone_basic_set", ofType: "json")

let rawHearthstoneJSON = NSData(contentsOfFile: pathForHearthstone!)

/* Error object */
var parsingAnimalsError: NSError? = nil

let parsedHearthstoneJSON = try NSJSONSerialization.JSONObjectWithData(rawHearthstoneJSON!, options: .AllowFragments) as! NSDictionary


func parseJSONAsDictionary(parsedHearthstoneJSON:NSDictionary) {
 
    if let dictArray = parsedHearthstoneJSON["Basic"] as? [[String:AnyObject]] {
    
        for dictionary in dictArray {
            
            if let id = dictionary["id"] as? String {
                print("id: \(id)")
            }
            
            if let name = dictionary["name"] as? String {
                print("name: \(name)")
            }
            
            if let type = dictionary["type"] as? String {
                print("type: \(type)")
            }
            
            if let collectible = dictionary["collectible"] as? Bool {
                print("collecible: \(collectible)")
            }
            
            if let cost = dictionary["cost"] as? Int {
                print("cost: \(cost)")
            }
        }
    }
}


parseJSONAsDictionary(parsedHearthstoneJSON)


