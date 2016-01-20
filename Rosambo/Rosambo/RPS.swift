//
//  RPS.swift
//  Rosambo
//
//  Created by Hyun on 2016. 1. 20..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation


enum RPS {
    
    case Rock, Paper, Scissors
    
    
    init() {
        // Randomly generate the number between 0 and 2
        switch arc4random() % 3 {
            
        case 0:
            self = .Rock
        case 1:
            self = .Paper
        default:
            self = .Scissors
        }
        
    }
    
    // Decide whether current RPS wins against the opponent
    func defeats(opponent: RPS)->Bool {
        
        switch(self, opponent) {
            
            case(.Paper, .Rock), (.Scissors, .Paper), (.Rock, .Scissors):
                return true
            default:
                return false
        }
    }
    
}

// Conform to CustomStringConvertible protocol 

extension RPS: CustomStringConvertible {
    
    var description: String {
        
        get {
            
            switch(self) {
            
            case .Rock:
                return "Rock"
            case .Scissors:
                return "Scissor"
            case .Paper:
                return "Paper"
            }
            
        }
    }
    
    
}