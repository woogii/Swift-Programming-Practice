//
//  Connection.swift
//  MYOA
//
//  Created by Hyun on 2016. 1. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

struct Connection {
    
    var prompt : String
    var connectToStoryNode: String
    
    init(dictionary:[String:String] ) {
        prompt = dictionary["prompt"]!
        connectToStoryNode = dictionary["connectTo"]!
    }
}