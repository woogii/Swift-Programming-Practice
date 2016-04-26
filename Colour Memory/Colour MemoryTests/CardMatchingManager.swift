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
    let penaltyPoint = -1
    
    // MARK : Initialization
    override init() {
        super.init()
    }
    
    convenience init(count:Int, pack: Pack ) {
        self.init()
        
        for _ in 0..<count {
            if let card = pack.pickRandomCard() {
                cards.append(card)
            }
        }
    }
    
    // MARK : Select Card At Index
    func selectCardAtIndex(index:Int) {
        
        if let card = cardAtIndex(index) {
        
            if ( card.isMatched == false ) {
                
                if( card.isSelected == true) {
                    card.isSelected = false
                } else {
                    
                    for otherCard in cards  {
                        
                        if otherCard.isSelected == true && otherCard.isMatched == false {
                            
                            let matchScore = card.match([otherCard])
                            
                            if (matchScore > 0 ) {
                                score = score + matchScore
                                otherCard.isMatched = true
                                card.isMatched = true
                            } else {
                                score = score + penaltyPoint
                                otherCard.isSelected = false
                            }
                            
                            break
                        }
                    }
                    card.isSelected = true
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