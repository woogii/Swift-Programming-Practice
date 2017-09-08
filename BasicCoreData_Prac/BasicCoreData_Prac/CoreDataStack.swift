//
//  CoreDataStack.swift
//  BasicCoreData_Prac
//
//  Created by siwook on 2017. 9. 8..
//  Copyright © 2017년 siwook. All rights reserved.
//

import Foundation
import CoreData


struct CoreDataStack {
  
  var managedContext:NSManagedObjectContext!
  
  init() {
    
    // load the NSManagedObjectModel from the application bundle
    
    guard let modelUrl = Bundle.main.url(forResource: "Item", withExtension: "momd") else {
      return
    }
    
    guard let model = NSManagedObjectModel(contentsOf: modelUrl) else {
      return
    }
    
    // Create NSPersistentStoreCoordinator with the Model
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    
    // Create NSManagedObjectContext
    
    self.managedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    self.managedContext.persistentStoreCoordinator = persistentStoreCoordinator
    
    guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
      fatalError("Unable to resolve document directory")
    }
      
    let storeURL = docURL.appendingPathComponent("Item.sqlite")
      
    do {
      
      // Add NSPersistentStore via NSPersistentStoreCoordinator
      try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
    } catch {
      fatalError("Error migrating store : \(error)")
    }
    
  }
  
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
