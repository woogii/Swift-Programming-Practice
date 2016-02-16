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