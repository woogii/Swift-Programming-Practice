//
//  Credits.swift
//  MYOA
//
//  Created by Hyun on 2016. 1. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

struct Credits {
    
    var key : String
    var author : String
    var imageName : String
    var source : String
    var title : String
    
    init(dictionary: [String:String]) {
        key = dictionary["key"]!
        author = dictionary["author"]!
        imageName = dictionary["image"]!
        source = dictionary["source"]!
        title = dictionary["title"]!
    }
    
    
}