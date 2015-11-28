//
//  MovieListViewController.swift
//  FavoriteActors
//
//  Created by Jason on 1/31/15.
//  Copyright (c) 2015 CCSF. All rights reserved.
//

import UIKit
import CoreData

class MovieListViewController : UITableViewController, NSFetchedResultsControllerDelegate  {
    
    var actor: Person!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if actor.movies.isEmpty {
            
            let resource = TheMovieDB.Resources.PersonIDMovieCredits
            let parameters = [TheMovieDB.Keys.ID : actor.id]
            
            TheMovieDB.sharedInstance().taskForResource(resource, parameters: parameters){ JSONResult, error  in
                if let error = error {
                    self.alertViewForError(error)
                } else {
                    
                    if let moviesDictionaries = JSONResult.valueForKey("cast") as? [[String : AnyObject]] {
                        
                        // Parse the array of movies dictionaries
                        _ = moviesDictionaries.map() { (dictionary: [String : AnyObject]) -> Movie in
                            let movie = Movie(dictionary: dictionary, context: self.sharedContext)
                            
                            // We associate this movie with it's actor by appending it to the array
                            // In core data we use the relationship. We set the movie's actor property
                            movie.actor = self.actor
                            
                            return movie
                        }
                        
                        // Update the table on the main thread
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                        
                        CoreDataStackManager.sharedInstance().saveContext()
                        
                    } else {
                        let error = NSError(domain: "Movie for Person Parsing. Cant find cast in \(JSONResult)", code: 0, userInfo: nil)
                        self.alertViewForError(error)
                    }
                }
            }
        }
    }
    
    // Mark: - Core Data Convenience
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    // MARK: - Fetched Results Controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        
        // Add a sort descriptor. This enforces a sort order on the results that are generated
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"title", ascending:false )]
        fetchRequest.predicate = NSPredicate(format: "actor == %@", self.actor)
        
        // Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()

    
    // MARK: - NSFetchedResultsControllerDelegate Protocol Methods
    // These four delegate methods are invoked when there is any change on this view controller
    
    /*
    This invocation prepares the table to receive a number of changes. It will store them up until
    it receives endUpdates(), and then perform them all at once.
    */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    // This method adds and removes rows in the table, in response to changes in the data
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert :
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete :
            tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update :
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ActorTableViewCell
            let movie = controller.objectAtIndexPath(indexPath!) as! Movie
            configureCell(cell, movie: movie)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    // When endUpdates is invoked, the table makes the changes visible
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }


    // MARK: - Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    
    /**
    The downloading of movie posters is handled here. Notice how the method uses a unique
    table view cell that holds on to a task so that it can be canceled.
    */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let CellIdentifier = "MovieCell"
        let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! Movie
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! TaskCancelingTableViewCell
        
        configureCell(cell, movie: movie)
        
        return cell
    }
    
    func configureCell( cell : TaskCancelingTableViewCell, movie:Movie) {
        
        cell.textLabel!.text = movie.title
        cell.imageView!.image = nil

        // Set the Movie Poster Image
        var posterImage = UIImage(named: "posterPlaceHoldr")
    
        if  movie.posterPath == nil || movie.posterPath == "" {
            posterImage = UIImage(named: "noImage")
        } else if movie.posterImage != nil {
            posterImage = movie.posterImage
        }
            
        else { // This is the interesting case. The movie has an image name, but it is not downloaded yet.
            
            // This first line returns a string representing the second to the smallest size that TheMovieDB serves up
            let size = TheMovieDB.sharedInstance().config.posterSizes[1]
            
            // Start the task that will eventually download the image
            let task = TheMovieDB.sharedInstance().taskForImageWithSize(size, filePath: movie.posterPath!) { data, error in
                
                if let error = error {
                    print("Poster download error: \(error.localizedDescription)")
                }
                
                if let data = data {
                    // Craete the image
                    let image = UIImage(data: data)
                    
                    // update the model, so that the infrmation gets cashed
                    movie.posterImage = image
                    
                    // update the cell later, on the main thread
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.imageView!.image = image
                    }
                }
            }
            
            // This is the custom property on this cell. See TaskCancelingTableViewCell.swift for details.
            cell.taskToCancelifCellIsReused = task
        }
        
        cell.imageView!.image = posterImage
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (editingStyle) {
        case .Delete:
            let actor = fetchedResultsController.objectAtIndexPath(indexPath) as! Person
            sharedContext.deleteObject(actor)
            CoreDataStackManager.sharedInstance().saveContext()
        default:
            break
        }
    }
    
    
    
    
    // MARK: - Alert View
    
    func alertViewForError(error: NSError) {
        
    }
}































