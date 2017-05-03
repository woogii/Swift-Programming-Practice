//
//  ViewController.swift
//  ImageCachingWithTableView
//
//  Created by siwook on 2017. 5. 2..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  let urlObject = URL(string: "https://itunes.apple.com/search?term=mario&entity=software")!
  var cache = NSCache<AnyObject,AnyObject>()
  var session : URLSession {
    return URLSession.shared
  }
  var parsedResults = [[String:AnyObject]]()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let urlRequest = URLRequest(url: urlObject)
    
    session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
      
      if error != nil {
        print("error occurred")
      } else {
        
        let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: [])
  
        if let convertedJsonResult = jsonResult as? [String:AnyObject], let jsonResult = convertedJsonResult["results"] as? [[String:AnyObject]] {
          self.parsedResults = jsonResult
  
          DispatchQueue.main.async {
            self.tableView.reloadData()
            
          }
        }
      }
      
      
    }).resume()
    
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return parsedResults.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.text = parsedResults[indexPath.row]["trackName"] as? String ?? ""
    cell.imageView?.image = UIImage(named: "Blank")
    
    let imageUrlString = parsedResults[indexPath.row]["artworkUrl60"] as? String ?? ""
    
    if let cachedImage = self.cache.object(forKey: imageUrlString as AnyObject) as? UIImage {
      
      cell.imageView?.image = cachedImage
      
    } else {
      
      if let imageUrl = URL(string:imageUrlString) {
        
        self.session.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
          
          if let _ = error {
            print("image request error")
          } else {
            
            let image = UIImage(data: data!)
            
            DispatchQueue.main.async {
              
              if let cell = tableView.cellForRow(at: indexPath) {
                print("image fetching in \(indexPath.row)")
                cell.imageView?.image = image
                self.cache.setObject(image!, forKey: imageUrlString as AnyObject)
              }
            }
          }
        }).resume()
      }
    }
    
    return cell
  }
  
  
}

