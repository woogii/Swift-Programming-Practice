//
//  StoryNode.swift
//  MYOA
//
//  Created by Hyun on 2016. 1. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation


struct StoryNode {
    
    var message : String
    
    private var adventure : Adventure
    private var connections : [Connection]
    
    var imageName : String? {
        return adventure.credits.imageName
    }
    
    func promptCount() -> Int {
        return connections.count
    }
    
    func promptForIndex(index:Int)->String{
        return connections[index].prompt
    }
    
    func storyNodeForIndex(index:Int) -> StoryNode {
        let storyNodeName = connections[index].connectToStoryNode
        let storyNode = adventure.storyNodes[storyNodeName]
        
        return storyNode!
    }
    
    init(dictionary:[String:AnyObject], adventure: Adventure) {
        
        self.adventure = adventure
        
        message = dictionary["message"] as! String
        print(message)
        connections = [Connection]()
        
        // \n is a literally in the file and not as a newline character, then we need to escape the \, like \\n
        message = message.stringByReplacingOccurrencesOfString("\\n", withString: "\n\n")
        
        if let connectionDictArray = dictionary["connections"] as? [[String:String]] {
        
            for connectionDict:[String:String] in connectionDictArray {
                connections.append(Connection(dictionary: connectionDict))
            }
        
        }
    }
    
}