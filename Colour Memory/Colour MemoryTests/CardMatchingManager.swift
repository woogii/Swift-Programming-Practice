//
//  CardMatchingManager.swift
//  Colour Memory
//
//  Created by Hyun on 2016. 4. 23..
//  Copyright © 2016년 siwook. All rights reserved.
//

import Foundation

// MARK : - CardMatchingManager : NSObject
class CardMatchingManager : NSObject {
    
    // MARK : Properties
    private var score:Int = 0
    private var cards = [Card]()
    
    // MARK : Initialization
    override init() {
        super.init()
    }

    /// Initialize CardMatchingManager object with given count and Pack object.
    /// Add randomly chosen Card object 'count' times to Pack Object
    /// - Parameter count : Number of Card
    /// - Parameter pack  : Pack Object
    /// - Returns: An initialized object
    convenience init(count:Int, pack: Pack ) {
        
        self.init()
        
        for _ in 0..<count {
            if let card = pack.pickRandomCard() {
                cards.append(card)
            }
        }
    }
    
    // MARK : Select Card At Index
    
    /// Get Card object at index in Card array and compare it with another Card object.
    /// Based on the result of the comparison, calculates the game score and sets properties of card objects accrodingly
    func selectCardAtIndex(index:Int) {

        var matchScore = 0
        
        guard let card = cardAtIndex(index) else {
            return
        }
        
        // Card is not matched
        if (card.isMatched == false) {
            
            // Mark card as selected 
            card.isSelected = true
                
            for otherCard in cards  {
                
                // If another card is selected but not matched
                if otherCard.isSelected == true && otherCard.isMatched == false && otherCard != card {
                    
                    // Match card against another card
                    matchScore = card.match([otherCard])
                        
                        
                    // If both card are matched
                    if (matchScore > 0) {
                        score = score + matchScore
                        otherCard.isMatched = true
                        card.isMatched = true
                   
                    } else {
                        // Not Matched, impose penalty
                        score = score + Constants.PenaltyPoint
                    }
                    break
                }
            }
        }
    }
    
    
    // MARK : Card Instance At Index
    func cardAtIndex(index:Int)->Card?{
        return index<cards.count ? cards[index] : nil
    }
    
    // MARK : Current Score
    func getScore()->Int {
        return score
    }
    
    // MARK : Number of matched cards
    func numOfMatchedCard()->Int{
        var num:Int = 0
        
        for card in cards {
            if card.isMatched {
                num = num + 1
            }
        }
        return num
    }
    
}