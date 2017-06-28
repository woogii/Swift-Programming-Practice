//
//  NotebooksTableViewController.swift
//  CoolNotes
//
//  Created by siwook on 2017. 6. 4..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit
import CoreData

class NotebooksTableViewController: CoreDataTableViewController {
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "CoolNotes"
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let stack = delegate.stack
    
    let fr = NSFetchRequest<NSFetchRequestResult>(entityName:"Notebook")
    fr.sortDescriptors = [NSSortDescriptor(key:"name", ascending:true),
                          NSSortDescriptor(key:"creationDate", ascending:false)]
    
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "NotebookCell", for: indexPath)

    let notebook = fetchedResultsController!.object(at: indexPath) as! Notebook
    
    
    cell.textLabel?.text = notebook.name
    cell.detailTextLabel?.text = "\(notebook.notes!.count) notes"
    
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "displayNote" {
      
      if let notesVC = segue.destination as? NotesViewController {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Note")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending:false)
          ,NSSortDescriptor(key:"text", ascending:true)]
        
        
        let indexPath = tableView.indexPathForSelectedRow!
        let notebook = fetchedResultsController?.object(at: indexPath)
        
        let predicate = NSPredicate(format: "notebook = %@", argumentArray: [notebook!])
        fetchRequest.predicate = predicate
        
        let fc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: fetchedResultsController!.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        notesVC.fetchedResultsController = fc
      }
    }
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "displayNote", sender: self)
  }
  
  @IBAction func addNewNotebook(_ sender: UIBarButtonItem) {
    
    
    
    
  }
  
  
  
  
}
