//
//  Card.swift
//  Colour Memory
//
//  Created by Hyun on 2016. 4. 23..
//  Copyright © 2016년 siwook. All rights reserved.
//

import Foundation

// MARK : - Card : NSObject
class Card : NSObject {
    
    // MARK : Properties
    var isSelected:Bool?
    var isMatched:Bool?
    var contents:String?
    let matchingPoint = 2
    
    // MARK : Matching Cards
    func match(otherCards:[Card])-> Int{
        var score = 0
        
        for otherCard in otherCards {
            if otherCard.contents == contents {
                score = score + matchingPoint
            } 
        }
        
        return score
    }
    
}