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
    func addItemInList(controller:ItemAddViewController, item:Item)
}

class ItemAddViewController : UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var delegate : ItemListViewController?
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancle")
        let saveBarButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "save")
        
        
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    func cancle(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        // If we use an array variable declared in AppDelegate.swift
        // let newItem = Item(price: Double(priceTextField.text!)!, name: nameTextField.text!)
        // appDelegate.items.append(newItem)
        
        //
        let newItem = Item(price: Double(priceTextField.text!)!, name: nameTextField.text!)
        delegate!.addItemInList(self, item: newItem)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}