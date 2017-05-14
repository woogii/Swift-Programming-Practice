//
//  AddViewController.swift
//  DataPassingByClosure
//
//  Created by siwook on 2017. 5. 13..
//  Copyright © 2017년 siwook. All rights reserved.
//

import Foundation
import UIKit

class AddViewController: UIViewController {
  
  @IBOutlet weak var inputTextField: UITextField!
  typealias customClosure = (String)->Void
  
  var addItemClosure:customClosure?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  
  @IBAction func pushAddButton(_ sender: UIButton) {
    
    if let wrappedClosure = addItemClosure {
      wrappedClosure(inputTextField.text ?? "")
    }
    
    _ = navigationController?.popViewController(animated: true)
  }
  
  
}
