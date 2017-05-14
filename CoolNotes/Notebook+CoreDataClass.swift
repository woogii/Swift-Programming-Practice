//
//  Notebook+CoreDataClass.swift
//  CoolNotes
//
//  Created by siwook on 2017. 5. 14..
//  Copyright © 2017년 siwook. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


class Notebook: NSManagedObject {

  // MARK: Initializer
  
  convenience init(name: String, context: NSManagedObjectContext) {
    
    // An EntityDescription is an object that has access to all
    // the information you provided in the Entity part of the model
    // you need it to create an instance of this class.
    if let ent = NSEntityDescription.entity(forEntityName: "Notebook", in: context) {
      self.init(entity: ent, insertInto: context)
      self.name = name;
      self.creationDate = NSDate()
    } else {
      fatalError("Unable to find Entity name!")
    }
  }

}
