//
//  PlayingCard.swift
//  Colour Memory
//
//  Created by Hyun on 2016. 4. 23..
//  Copyright © 2016년 siwook. All rights reserved.
//

import Foundation

// MARK : - PlayingCard : Card 
class PlayingCard : Card {
    
    var colourDesc: String?
    // static let suitSet = ["☁️","💧","❤️","⭐️","🌛","🎵","☀️","👑"]
    
    // MARK : Property
    static let colourSet = ["blue","brown","darkGreen","green","lightBlue","olive","purple","red"]
    
    // MARK : Initialization
    override init() {
        super.init()
    }
    
    convenience init(let colourDesc:String) {

        self.init()
        
        // Set colourDesc property value
        if(PlayingCard.colourSet.contains(colourDesc)) {
            self.colourDesc = colourDesc
        }
    }
    
    // MARK : Matching Cards
    override func match(otherCards:[Card])-> Int{
        var score = 0
        
        if(otherCards.count == 1) {
            
            if let otherCard = otherCards.first as? PlayingCard {
                
                if colourDesc == otherCard.colourDesc {
                    score = score + matchingPoint
                }
            }
        }
        
        return score
    }


}