//
//  UploadImageViewController.swift
//  Scientific Innovations
//
//  Created by siwook on 2017. 6. 28..
//  Copyright © 2017년 siwook. All rights reserved.
//
import UIKit
import Alamofire

class UploadImageViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func pushUploadButton(_ sender: UIButton) {
    
    let image = UIImage(named: "placeholder")!
    let base64String = UIImagePNGRepresentation(image)?.base64EncodedString(options:[.init(rawValue: 0)])
    
  
    let parameters = ["file" : base64String as Any] as [String:Any]
    let finalUrl = "http://poc.nexuslab.co/api/image-upload"
  
    Alamofire.upload(multipartFormData: {  multipartFormData in
      
      if let imageData = UIImageJPEGRepresentation(image,0.5) {
        
        multipartFormData.append(imageData, withName: "file", fileName: "placeholder.jpg", mimeType: "image/jpeg")
      }
      
      for (key, value) in parameters {
        multipartFormData.append((value as AnyObject).data(using:String.Encoding.utf8.rawValue)!, withName: key)
      }
      
    }, to : finalUrl, encodingCompletion: {  encodingResult in
      
      switch encodingResult {
        
      case .success(let upload, _, _):
        upload.validate()
        upload.responseJSON { response in
          print(response)
        }
  
      case .failure( _):
    
        #if DEBUG
          print("encodingResult error")
        #endif
      }
    })

    
  }
  
}

