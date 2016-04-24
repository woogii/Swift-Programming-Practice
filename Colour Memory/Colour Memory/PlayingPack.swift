//
//  PlayingPack.swift
//  Colour Memory
//
//  Created by Hyun on 2016. 4. 23..
//  Copyright © 2016년 siwook. All rights reserved.
//

import Foundation

// MARK : - PlayingPack : Pack
class PlayingPack : Pack {
    
    let pair = 2
    
    // MARK : Initialization
    override init() {
        
        super.init()
    
        // Add 8 pairs of colour cards
        for _ in 0..<pair {
            for j in 0..<PlayingCard.colourSet.count {
                let card = PlayingCard(colourDesc: PlayingCard.colourSet[j])
                addCard(card)
            }
        }
        

    }
}