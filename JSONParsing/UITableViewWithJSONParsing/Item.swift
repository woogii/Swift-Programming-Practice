//
//  Item.swift
//  UITableViewWithJSONParsing
//
//  Created by siwook on 2017. 5. 13..
//  Copyright © 2017년 siwook. All rights reserved.
//

import Foundation

class Item {
  
  var name:String?
  var releaseDate:Date
  var imageName:String
  
  let dateFormat:DateFormatter = {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "YYYY-MM-dd"
    return dateFormat
  }()
  
  init(dict:[String:AnyObject]) {
    
    name = dict["name"] as? String
    
    if let dateString = dict["release_date"] as? String {
      releaseDate = dateFormat.date(from: dateString)!
    } else {
      releaseDate = Date.distantFuture
    }
    
    imageName = dict["image"] as? String ?? ""
  }
  
  static func createItemList(dictArray:[[String:AnyObject]])->[Item] {
    var itemList = [Item]()
    
    for dict in dictArray {
      let item = Item(dict: dict)
      itemList.append(item)
    }
    
    return itemList
  }
  
}
