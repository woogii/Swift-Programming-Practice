//
//  Pack.swift
//  Colour Memory
//
//  Created by Hyun on 2016. 4. 23..
//  Copyright © 2016년 siwook. All rights reserved.
//

import Foundation

// MARK : - Pack : NSObject 
class Pack : NSObject {
    
    // MARK : Property
    var cards = [Card]()
    
    // MARK : Add Card
    func addCard(newCard:Card) {
        cards.append(newCard)
    }
    
    // MARK : Pick Random Card 
    func pickRandomCard()->Card?{
        
        var randomCard:Card?
        
        if cards.count > 0  {
            // Pick random card and delete it from the card pack
            let index = Int(arc4random_uniform(UInt32(cards.count)))
            randomCard = cards[index]
            cards.removeAtIndex(index)
        }
        
        return randomCard
    }
}