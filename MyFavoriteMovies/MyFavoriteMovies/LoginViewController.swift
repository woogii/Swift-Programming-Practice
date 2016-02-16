//
//  LoginViewController.swift
//  MyFavoriteMovies
//
//  Created by Hyun on 2016. 2. 12..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    var appDelegate : AppDelegate!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginResponse: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        subscribeNotification(TMDBConstants.Selectors.KeyboardWillShow, notification: UIKeyboardWillShowNotification )
        subscribeNotification(TMDBConstants.Selectors.KeyboardWillHide, notification: UIKeyboardWillHideNotification);
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture" )
        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func handleTapGesture() {
        // Cause the view to resign the first responder status
        view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubsribeNotification(UIKeyboardWillShowNotification)
        unsubsribeNotification(UIKeyboardWillHideNotification)
    }
    
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            loginResponse.text = "Username or Password Empty."
        } else {
            getRequestToken()
        }
        
    }
        
    func getRequestToken() {
        
        let methodParameters = [ TMDBConstants.TMDBParamKeys.APIKey : TMDBConstants.TMDBParameterValues.APIKey ]
        print(methodParameters)
        let url = appDelegate.generateURL(methodParameters, withPathExtension: TMDBConstants.TMDB.APIAuthTokenNew)
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = appDelegate.session.dataTaskWithRequest(request)  {  (data, response, error) in
            
            func displayError(errorMessage:String) {
                print(errorMessage)
            }
            
            guard error == nil  else {
                displayError("There was an error with your request")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299  else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                displayError("No date was returned by the request!")
                return
            }
            
            let parsedResult:AnyObject!
            
            do  {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                print(parsedResult)
                
                guard let requestToken = parsedResult[TMDBConstants.TMDBResponseKeys.RequestToken] as? String else{
                    displayError("Can not parse data with a key \(TMDBConstants.TMDBResponseKeys.RequestToken)")
                    return
                }
                
                 self.validateLogin(requestToken)
                
                
            } catch {
                print("error")
            }
        }
        
        task.resume()
        
    }
    
    func validateLogin(requestToken:String) {
    
        let methodParamethers = [
            TMDBConstants.TMDBParamKeys.APIKey : TMDBConstants.TMDBParameterValues.APIKey,
            TMDBConstants.TMDBParamKeys.RequestToken : requestToken,
            TMDBConstants.TMDBParamKeys.Username : TMDBConstants.TMDBParameterValues.Username,
            TMDBConstants.TMDBParamKeys.Password : TMDBConstants.TMDBParameterValues.Password
        ]
        
        let url = appDelegate.generateURL(methodParamethers, withPathExtension: TMDBConstants.TMDB.APIValidateLogin)
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = appDelegate.session.dataTaskWithRequest(request) {  (data, response, error) in
            
            func displayError(errorMessage:String) {
                print(errorMessage)
            }
            
            guard error == nil else {
                displayError("There was an error with your request")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2XX")
                return
            }
            
            guard let data = data else{
                displayError("No data was returned by the request!")
                return
            }
            
            let parsedResult:AnyObject!
            
            do {
                
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                guard let success = parsedResult[TMDBConstants.TMDBResponseKeys.Success] as? Int else {
                    displayError("Cannot parse the result with a key \(TMDBConstants.TMDBResponseKeys.Success)")
                    return
                }
                print(parsedResult)
                
                if success==1 {
                   self.getSessionId(requestToken)
                } else {
                    displayError("Your login information is not valid")
                    return
                }
                
                
            } catch let error as NSError {
                displayError(error.description)
            }
        }
        
        task.resume()
    }
    
    func getSessionId(requestToken:String) {
     
        let methodParameters = [
            TMDBConstants.TMDBParamKeys.APIKey : TMDBConstants.TMDBParameterValues.APIKey,
            TMDBConstants.TMDBParamKeys.RequestToken : requestToken
        ]
        
        let url = appDelegate.generateURL(methodParameters, withPathExtension: TMDBConstants.TMDB.APISessionNew)
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = appDelegate.session.dataTaskWithRequest(request) { (data, response, error) in
            
            func displayError(errorMessage:String) {
                print(errorMessage)
                return
            }
            
            guard error == nil else {
                
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                
                displayError("Your request returned a status code other than 2XX")
                return
            }
            
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            
            let parsedResult:AnyObject!
            do {
                
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                guard let sessionId = parsedResult[TMDBConstants.TMDBResponseKeys.SessionID] as? String else {
                    displayError("Can not parse the data with a key : \(TMDBConstants.TMDBResponseKeys.SessionID)")
                    return
                }
                
                print("Session ID : \(sessionId)")
                
            } catch let error as NSError {
                print(error.description)
            }
        
            
        }
        task.resume()
    }
    
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func keyboardWillShow(notification:NSNotification) {
        
        if let userInfo = notification.userInfo {
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            view.frame.origin.y = -keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        view.frame.origin.y = 0
    }
    
    
   
}

extension LoginViewController {

    func subscribeNotification(selector:Selector, notification : String) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubsribeNotification(notification : String) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: notification, object: nil)
    }
}