//
//  Adventure.swift
//  MYOA
//
//  Created by Hyun on 2016. 1. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

class Adventure {
    
    var credits : Credits
    var startNode : StoryNode!
    
    var storyNodes = [String: StoryNode]()

    init(dictionary: [String: AnyObject]) {
        
        let creditDictionary = dictionary["credits"] as! [String:String]
        let storyNodeDictionary = dictionary["nodes"] as! [String:AnyObject]
        

        credits = Credits(dictionary: creditDictionary)
      
        for (key, dictionary) in storyNodeDictionary {
            self.storyNodes[key] = StoryNode(dictionary: dictionary as! [String : AnyObject], adventure: self)
        }
        
        let startNodeKey = dictionary["startNodeKey"] as! String
        startNode = storyNodes[startNodeKey]
    }
    
    
}