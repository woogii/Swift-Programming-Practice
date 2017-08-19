//
//  ViewController.swift
//  RxSwiftIntro
//
//  Created by siwook on 2017. 8. 19..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  @IBOutlet weak var loginEnabledLabel: UILabel!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  var loginViewModel = LoginViewModel()
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    _ = emailTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.emailText)
    _ = passwordTextField.rx.text.map { $0 ?? ""}.bind(to: loginViewModel.passwordText)
    
    _ = loginViewModel.isValid.bind(to: loginButton.rx.isEnabled)
    
    loginViewModel.isValid.subscribe( onNext : { [unowned self] isValid in
      self.loginEnabledLabel.text = isValid ? "Enabled" : "Not Enabled"
      self.loginEnabledLabel.textColor = isValid ? .green : .red
      print("isValid = \(isValid)")
    }).addDisposableTo(disposeBag)
  }

  

}

