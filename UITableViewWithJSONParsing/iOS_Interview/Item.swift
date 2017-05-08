//
//  Item.swift
//  iOS_Interview
//
//  Created by siwook on 2017. 5. 8..
//  Copyright © 2017년 siwook. All rights reserved.
//

import Foundation
import UIKit


// MARK : - Item

class Item  {
  
  // MARK : - Property 
  
  var name :String?
  var releaseDate : String
  var imageName:String
  
  let formattter : DateFormatter  = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
  
  // MARK : - Initialization 
  
  init(name:String?, releaseDate:String, imageName:String) {
    
    self.name = name
    self.releaseDate = releaseDate
    self.imageName = imageName
    
  }
  
  init(json:[String:AnyObject]) {
  
    if let name = json["name"] as? String {
      self.name = name
    }
    
    if let date = json["release_date"] as? String {
      self.releaseDate = date
    } else {
      self.releaseDate = formattter.string(from: NSDate.distantFuture)
    }
    
    self.imageName = json["image"] as? String ?? ""
  }
  

  // MARK : - Create Item List 
  
  static func createItemList(jsonArray:[[String:AnyObject]])->[Item] {
  
    var itemList = [Item]()
    
    for json in jsonArray {
      
      let item = Item(json: json)
      itemList.append(item)
    }
    
    return itemList
  }
  
}
