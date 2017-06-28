//
//  Note+CoreDataProperties.swift
//  CoolNotes
//
//  Created by siwook on 2017. 5. 14..
//  Copyright © 2017년 siwook. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Note {

    @NSManaged public var text: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var notebook: Notebook?

}
