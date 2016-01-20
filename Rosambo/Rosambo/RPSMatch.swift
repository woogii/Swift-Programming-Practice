//
//  RPSMatch.swift
//  Rosambo
//
//  Created by Hyun on 2016. 1. 20..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation


struct RPSMatch {
    
    let p1: RPS
    let p2: RPS
    
    
    init(p1: RPS, p2: RPS) {
        self.p1 = p1
        self.p2 = p2
    }
    
    var winner : RPS {
        
        get {
            return p1.defeats(p2) ? p1 : p2
        }
    }
    
    var loser: RPS {
        
        get {
            return p1.defeats(p2) ? p2: p1
        }
    }
    
}