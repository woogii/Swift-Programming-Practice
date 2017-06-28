//
//  NotesViewController.swift
//  CoolNotes
//
//  Created by siwook on 2017. 6. 6..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit

class NotesViewController: CoreDataTableViewController {
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let note = fetchedResultsController?.object(at: indexPath) as! Note
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
    
    cell.textLabel?.text = note.text
    
    return cell
  }
  
  @IBAction func addNewNote(_ sender: UIBarButtonItem) {
    
    
    
    
  }
  
}
