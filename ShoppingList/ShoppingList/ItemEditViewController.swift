//
//  ItemEditViewController.swift
//  ShoppingList
//
//  Created by Hyun on 2016. 3. 12..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : Define delegate protocol
protocol ItemEditViewControllerDelegate {
    
    func editItemInList(controller : ItemEditViewController, editItem item: Item)
}

class ItemEditViewController : UIViewController {
    
    // MARK : Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var item:Item!
    var delegate: ItemEditViewControllerDelegate?

    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        nameTextField.text = item.name
        priceTextField.text = "\(item.price)"
    }

    // MARK : Configure UI
    func configureUI() {
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonTapped")
        self.navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    // MARK : Action
    func saveButtonTapped() {
        if let name = nameTextField.text , let priceText = priceTextField.text , let price = Float(priceText) {
            // Update values
            item.name = name
            item.price = price
            // Call delegate method
            delegate?.editItemInList(self, editItem: item)
        }
        // Pop View Controller
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}