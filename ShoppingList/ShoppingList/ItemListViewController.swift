//
//  ViewController.swift
//  ShoppingList
//
//  Created by Hyun on 2016. 3. 12..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController, ItemAddViewControllerDelegate {

    // MARK : - Property
    @IBOutlet weak var tableView: UITableView!
    
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    let cellIdentifier = "itemCell"
    
    // MARK : - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        appDelegate.items.append(Item(price: 5000, name: "banana"))
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func configureUI() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem:")
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editItem:")
        
        self.navigationItem.rightBarButtonItem = editButton
        self.navigationItem.leftBarButtonItem = addButton

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

 
    func addItem(barButtonItem: UIBarButtonItem) {
        //let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ItemAddViewController")
        // as! ItemAddViewController
        // presentViewController(controller, animated: true, completion: nil)
        performSegueWithIdentifier("showAddView", sender: self)
    }
    
    func editItem(barButtonItem: UIBarButtonItem) {
        
    }
    
    func addItemInList(controller: ItemAddViewController, item: Item) {
        appDelegate.items.append(item)
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if( segue.identifier == "showAddView") {
            let naviController = segue.destinationViewController as! UINavigationController
            let itemAddViewController = naviController.topViewController as! ItemAddViewController
            itemAddViewController.delegate = self
        }
    }
    
}

extension ItemListViewController : UITableViewDelegate, UITableViewDataSource {
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel!.text = appDelegate.items[indexPath.row].name
        return cell
    }

}
