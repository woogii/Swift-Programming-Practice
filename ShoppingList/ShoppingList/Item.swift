//
//  Item.swift
//  ShoppingList
//
//  Created by Hyun on 2016. 3. 12..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

struct Item {
    
    var price:Double
    var name:String
    
    init(price:Double, name:String){
        self.price = price
        self.name = name
    }
}