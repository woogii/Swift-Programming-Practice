//
//  Villain.swift
//  BondVillains
//
//  Created by Hyun on 2016. 1. 25..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation


struct Villain {
    

    let name : String
    let evilScheme : String
    let imageName : String
    
    static let NameKey = "NameKey"
    static let EvilSchemeKey = "EvilScheme"
    static let ImageNameKey = "ImageNameKey"
    
    init(dictionary:[String:String]) {
        
        name = dictionary["NameKey"]!
        evilScheme = dictionary["EvilScheme"]!
        imageName = dictionary["ImageNameKey"]!
    }
    
}


// This extension adds static variable which is an array of Villain object

extension Villain {
    
    static var allVillain : [Villain] {
        
        var villainArray = [Villain]()
        
        for villainDict in Villain.localVillainData() {
            villainArray.append(Villain(dictionary: villainDict))
        }
        
        return villainArray
    }
    
    static func localVillainData()-> [[String:String]] {
    
        return [
            [Villain.NameKey : "Mr.Big", Villain.EvilSchemeKey: "Smuggle heroin.", Villain.ImageNameKey: "Big"],
            [Villain.NameKey : "Ernest Blofeld", Villain.EvilSchemeKey : "Many, many, schemes.",  Villain.ImageNameKey : "Blofeld"],
            [Villain.NameKey : "Sir Hugo Drax", Villain.EvilSchemeKey : "Nerve gass Earth, from the Moon.",  Villain.ImageNameKey : "Drax"],
            [Villain.NameKey : "Jaws", Villain.EvilSchemeKey : "Kill Bond with huge metal teeth.",  Villain.ImageNameKey : "Jaws"],
            [Villain.NameKey : "Rosa Klebb", Villain.EvilSchemeKey : "Humiliate MI6",  Villain.ImageNameKey : "Klebb"],
            [Villain.NameKey : "Emilio Largo", Villain.EvilSchemeKey : "Steal nuclear weapons", Villain.ImageNameKey : "EmilioLargo"],
            [Villain.NameKey : "Le Chiffre", Villain.EvilSchemeKey : "Beat bond at poker.",  Villain.ImageNameKey : "Lechiffre"],
            [Villain.NameKey : "Odd Job", Villain.EvilSchemeKey : "Kill Bond with razor hat.",  Villain.ImageNameKey : "OddJob"],
            [Villain.NameKey : "Francisco Scaramanga", Villain.EvilSchemeKey : "Kill Bond after assembling a golden gun.",  Villain.ImageNameKey : "Scaramanga"],
            [Villain.NameKey : "Raoul Silva", Villain.EvilSchemeKey : "Kill M.",  Villain.ImageNameKey : "Silva"],
            [Villain.NameKey : "Alec Trevelyan", Villain.EvilSchemeKey : "Nuke London, after killing Bond.",  Villain.ImageNameKey : "Trevelyan"],
            [Villain.NameKey : "Auric Goldfinger", Villain.EvilSchemeKey : "Nuke Fort Knox.",  Villain.ImageNameKey : "Goldfinger"],
            [Villain.NameKey : "Max Zorin", Villain.EvilSchemeKey : "Destroy Silicon Valley with an earthquake and flood.",  Villain.ImageNameKey : "Zorin"]        ]
    }
    
    
}