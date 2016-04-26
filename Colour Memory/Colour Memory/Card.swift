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
    var isSelected:Bool = false
    var isMatched:Bool = false 
    var colourDesc:String?
    let matchingPoint = 5
    
    // MARK : Matching Cards
    func match(otherCards:[Card])-> Int{
        var score = 0
        
        for otherCard in otherCards {
            if otherCard.colourDesc == colourDesc {
                score = score + matchingPoint
            } 
        }
        
        return score
    }
    
}