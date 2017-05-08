//
//  RestClient.swift
//  iOS_Interview
//
//  Created by siwook on 2017. 5. 8..
//  Copyright © 2017년 siwook. All rights reserved.
//

import Foundation


// MARK: - RestClient : NSObject

class RestClient : NSObject {

  // MARK: - Property
  
  static let sharedInstance = RestClient()
  private var session: URLSession!
  typealias CompletionHandler  = (_ result:AnyObject?, _ error:Error?) -> Void
  
  // MARK: - Initialization
  
  override init() {
    
    session = URLSession.shared
    super.init()
  }

  
  // MARK: - Imitating HTTP Request
  
  func getDataFromServer(urlString: String, parameters: [String : AnyObject]?=nil, completionHandler: @escaping CompletionHandler)->URLSessionDataTask? {
    
    guard let url = URL(string:urlString) else {
      return nil
    }
    
    let request = URLRequest(url: url)
  
    let task = URLSession.shared.dataTask(with: request) { (result,response, error) in
      
      if let error = error {
        completionHandler(nil, error)
      } else {
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
          print(error?.localizedDescription as Any)
          return
        }
        
        completionHandler(result as AnyObject?, nil)
        
      }
      
    }
    
    task.resume()
    
    return task
    
  }

}
