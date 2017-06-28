//
//  ViewController.swift
//  Scientific Innovations
//
//  Created by siwook on 2017. 6. 28..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit
import Alamofire

class LogInViewController: UIViewController {
  
  @IBOutlet weak var passwordView: UIView!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var emailView: UIView!
  @IBOutlet weak var emailTextField: UITextField!
  
  struct Constants {
    static let LogInSuccess = 1
    static let LogInFail = 0
    static let SegueID = "showUploadVC"
    static let BaseURL = "http://poc.nexuslab.co/api/login"
    
    struct Parameters {
      
      static let EmailKey = "email"
      static let EmailValue = "test@interview.lab"
      static let PasswordKey = "password"
      static let PasswordValue = "123456"
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addBorderToViews()
  }
  
  func addBorderToViews() {
    passwordView.layer.borderColor = UIColor.gray.cgColor
    emailView.layer.borderColor = UIColor.gray.cgColor
  }
  
  @IBAction func pushLogInButton(_ sender:
    UIButton) {
    
    let parameters = [Constants.Parameters.EmailKey: Constants.Parameters.EmailValue
      ,Constants.Parameters.PasswordKey:Constants.Parameters.PasswordValue]
    
    Alamofire.request(Constants.BaseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
      .validate()
      .responseJSON { (response) -> Void in
        
        #if DEBUG
          print("Response result: \(response)")
          print("Response result: \(response.result.value)")
          print("Response result error: \(response.result.error)")
        #endif
        
        switch response.result {
          
        case .success:
          
          if let result = response.result.value as? Int {
            
            if result == Constants.LogInSuccess {
              DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.SegueID, sender: self)
              }
            }
          }
          
          break
          
        case .failure(_):
          
          break
          
        }
    }
    
    
  }
}

