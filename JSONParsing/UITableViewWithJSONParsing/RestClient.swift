//
//  RestClient.swift
//  UITableViewWithJSONParsing
//
//  Created by siwook on 2017. 5. 13..
//  Copyright © 2017년 siwook. All rights reserved.
//

import Foundation

class RestClient : NSObject {
  
  static let sharedInstance = RestClient()
  
  typealias SuccessCallBack = (_ results:[String:AnyObject]?)->Void
  typealias FailCallBack = (_ error:Error)->Void
  
  var sharedSession: URLSession {
    return URLSession.shared
  }
  
  override init() {
    super.init()
  }
  
  func requestImage(successCallBack: @escaping SuccessCallBack, failCallBack: @escaping FailCallBack) {
    
    let urlString = "https://www.rakuten.co.jp"
    let url = URL(string: urlString)!
    
    _ = sharedSession.dataTask(with: url, completionHandler: { (data, response, error) in
      
      if let error = error {
        failCallBack(error)
      } else {
        
        let statusCode =  (response as! HTTPURLResponse).statusCode
        print("status Code : \(statusCode)")
        if 200...299 ~= statusCode {
          successCallBack(nil)
        }
      }
    }).resume()
    
  }
}
