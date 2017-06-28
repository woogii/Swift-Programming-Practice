//
//  AppDelegate.swift
//  CoolNotes
//
//  Created by siwook on 2017. 5. 14..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let stack = CoreDataStack(modelName: "Model")!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    preloadData()
    return true
  }


  func preloadData() {
    
    do {
      try stack.dropAllData()
    } catch {
      print("Error droping all objects in DB")
    }
    
    let codeNotes = Notebook(name: "Coding Notes", context: stack.context)
    let appIdeas = Notebook(name: "Ideas for new Apps", context: stack.context)
    
    
    print(codeNotes)
    print(appIdeas)
    
    let wwdc = Note(text: "Watch some WWDC sessions", context: stack.context)
    let kitura = Note(text: "Learn about Kitura, a web framework in Swift by IBM", context: stack.context)
    
    print(wwdc)
    print(kitura)
    
    wwdc.notebook = codeNotes
    kitura.notebook = codeNotes
    
    let daDump = Note(text: "daDump : social network for people using the toilet", context: stack.context)
    daDump.notebook = appIdeas
    
  }


}

