//
//  ScoreList.swift
//  Colour Memory
//
//  Created by Hyun on 2016. 5. 1..
//  Copyright © 2016년 siwook. All rights reserved.
//

import Foundation
import CoreData

class ScoreList : NSManagedObject {

    @NSManaged var name : String
    @NSManaged var score: NSNumber
    @NSManaged var date : NSDate
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context : NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary : [String:AnyObject], context : NSManagedObjectContext?) {
        
        let entity = NSEntityDescription.entityForName(Constants.EntityName, inManagedObjectContext: context!)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        name  = dictionary[Constants.KeyName]  as! String
        score = dictionary[Constants.KeyScore] as! Int
        date  = dictionary[Constants.KeyDate]  as! NSDate
        
    }
}