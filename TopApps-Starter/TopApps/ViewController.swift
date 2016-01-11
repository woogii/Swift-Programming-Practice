//
//  ViewController.swift
//  TopApps
//
//  Created by Dani Arnaout on 9/1/14.
//  Edited by Eric Cerney on 9/27/14.
//  Copyright (c) 2014 Ray Wenderlich All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        // Parsing JSON by using SwiftJSON
        
        DataManager.getTopAppsDataFromFileWithSuccess { (data) -> Void in
            // Get #1 app name using SwiftyJSON
            let json = JSON(data: data)
            if let appName = json["feed"]["entry"][0]["im:name"]["label"].string {
                print("SwiftyJSON: \(appName)")
            }
        }
    
        DataManager.getTopAppsDataFromItunesWithSuccess( { (iTunesData) -> Void in
        
        
            let json = JSON(data: iTunesData)
            
            if let appName = json["feed"]["entry"][0]["im:name"]["label"].string {
                print("NSURLSession: \(appName)")
            }
            
            if let appArray = json["feed"]["entry"].array {
                
                var apps = [AppModel]()
                
                for appDict in appArray {
                    
                    let appName : String? = appDict["im:name"]["label"].string
                    let appURL : String? = appDict["im:image"][0]["label"].string
                    
                    let app = AppModel(name: appName, appStoreURL: appURL)
                    apps.append(app)
                }
                
                print(apps)
            }
            

        
        
        #if false
            
        do {
            // Parsing JSON by using NSJSONSerialization
            let parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let feed = parsedObject["feed"] as? NSDictionary {

                if let entryList = feed["entry"] as? [NSDictionary] {
                    
                    if let nameLable = (entryList[0])["im:name"] as? NSDictionary {
                        if let name = nameLable["label"] as? String {
                            print(name)
                        }
                    }
                }
            }
            
        } catch let error as NSError  {
            print(error.description)
        }
        
        #endif
        
        
      })
   }
}

