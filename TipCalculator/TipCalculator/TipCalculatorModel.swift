//
//  TipCalculatorModel.swift
//  TipCalculator
//
//  Created by Hyun on 2015. 11. 7..
//  Copyright © 2015년 wook2. All rights reserved.
//

import Foundation

class TipCalculatorModel {
    
    var total: Double
    var taxPct: Double
    var subtotal : Double {
        get {
            return total/(taxPct+1)
        }
    }
    
    init(total:Double, taxPct : Double) {
        self.total = total
        self.taxPct = taxPct
    }
    
    func calcTipWithTipPct(tipPct:Double) -> Double {
        return subtotal * tipPct
    }
    
    func returnPossibleTips() -> [Int:Double]  {
        let possibleTipsInferred = [0.15,0.18,0.20]
        
        var retval = [Int:Double]()
        
        for possibleTip in possibleTipsInferred {
            let intPct = Int(possibleTip*100)
            retval[intPct] = calcTipWithTipPct(possibleTip)
        }
        
        return retval
    }
}