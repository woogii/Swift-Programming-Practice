//
//  ItemEditViewController.swift
//  ShoppingList
//
//  Created by Hyun on 2016. 3. 12..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit



class ItemDetailViewController : UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var item:Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonTapped")
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(animated: Bool) {
        nameTextField.text = item.name
        priceTextField.text = "\(item.price)"
    }
    
    func saveButtonTapped() {
        
    }
    
    
}