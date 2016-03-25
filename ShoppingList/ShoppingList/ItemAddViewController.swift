//
//  ItemAddViewController.swift
//  ShoppingList
//
//  Created by Hyun on 2016. 3. 12..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

protocol ItemAddViewControllerDelegate {
    func addItemInList(controller:ItemAddViewController, addedItem item:Item)
}

class ItemAddViewController : UIViewController {
    
    // MARK : Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var delegate : ItemAddViewControllerDelegate?

    // MARK : View Life Cycle   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK : Configure UI
    func configureUI() {
        
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancle")
        let saveBarButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "save")
        
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    // MARK : Actions 
    
    func cancle(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        
        if let name = nameTextField.text, let priceText = priceTextField.text, let price = Float(priceText) {
            // Call delegate method
            delegate!.addItemInList(self, addedItem: Item(name:name, price:price))
        
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
}