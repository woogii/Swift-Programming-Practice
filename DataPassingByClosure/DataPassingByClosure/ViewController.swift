//
//  ViewController.swift
//  DataPassingByClosure
//
//  Created by siwook on 2017. 5. 13..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  lazy var itemList : [String] = {
    let itemList = ["Wake up", "Go to School", "Hang out with Friends"]
    return itemList
  }()
  
  let button : UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 45))
    button.setTitle("Test", for: .normal)
    return button
  }()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    button.center = self.view.center
    
    button.addTarget(self, action: #selector(pushButton(_:)), for: .touchUpInside)
  }

  func pushButton(_ sender:UIButton) {
    
  }
  
  @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let destinationVC = storyboard.instantiateViewController(withIdentifier: "AddVC") as! AddViewController
    destinationVC.addItemClosure = { (item) in
      self.itemList.append(item)
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    navigationController?.pushViewController(destinationVC, animated: true)
  }
 

}


extension ViewController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.text = itemList[indexPath.row]
    
    return cell
  }
  
}



