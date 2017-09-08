//
//  AppDelegate.swift
//  BasicCoreData_Prac
//
//  Created by siwook on 2017. 9. 8..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  lazy var managedContext: NSManagedObjectContext = {
    let persistentContainer = NSPersistentContainer(name:"Item")
    persistentContainer.loadPersistentStores { (description, error) in
      if let error = error {
        fatalError("Failed to load Core Data stack: \(error)")
      }
    }
    return persistentContainer.viewContext
  }()
  
  func save() {
    
    if managedContext.hasChanges {
      do {
        try managedContext.save()
      } catch let error as NSError {
        print("\(error.userInfo)...\(error.localizedDescription)")
      }
    }
  }
    
}

