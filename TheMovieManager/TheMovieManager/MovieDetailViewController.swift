//
//  MovieDetailViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - MovieDetailViewController: UIViewController

class MovieDetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var toggleFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var toggleWatchlistButton: UIBarButtonItem!
    
    var movie: TMDBMovie?
    
    var favoriteList =  [TMDBMovie]()
    var watchList = [TMDBMovie]()
    
    var isFavorite = false
    var isWatchlist = false
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get favorite movies, then update the favorite button
        TMDBClient.sharedInstance().getFavoriteMovies() {  (movies, error) in
            
            if let error = error {
                print(error)
            } else {
                
                if let movies = movies {
                    
                    for movieInFavorite in movies {
                        if movieInFavorite.title == self.movie!.title {
                            dispatch_async(dispatch_get_main_queue()){
                            self.toggleFavoriteButton.tintColor = nil
                            }
                            
                        }
                    }
                    
                } else {
                    print("there are no movies on the favorite list")
                }
            }
            
        }
        
        // Get watchlist movies, then update the watchlist button
        TMDBClient.sharedInstance().getWatchlistMovies() {  (movies, error) in
            
            if let error = error {
                print(error)
            } else {
                
                if let movies = movies {
                    print(movies)
                    for movieInFavorite in movies {
                        if movieInFavorite.title == self.movie!.title {
                            dispatch_async(dispatch_get_main_queue()){
                                self.toggleWatchlistButton.tintColor = nil
                            }
                        }
                    }
                    
                } else {
                    print("there is no movie on the watchlist")
                }
            }
            
        }
       
        // Get the poster image, then populate the poster image view
        if let posterPath = self.movie!.posterPath {
            TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.DetailPoster, filePath: posterPath, completionHandler: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.posterImageView!.image = image
                    }
                } else {
                    print(error)
                }
            })
        }
    
    }
    
    // MARK: Actions
    
    @IBAction func toggleFavoriteButtonTouchUp(sender: AnyObject) {
        if isFavorite {
            TMDBClient.sharedInstance().postToFavorites(movie!, favorite: false) { status_code, error in
                if let err = error {
                    print(err)
                } else {
                    if status_code == 13 {
                        self.isFavorite = false
                        dispatch_async(dispatch_get_main_queue()) {
                            self.toggleFavoriteButton.tintColor = UIColor.blackColor()
                        }
                    } else {
                        print("Unexpected status code \(status_code)")
                    }
                }
            }
        } else {
            TMDBClient.sharedInstance().postToFavorites(movie!, favorite: true) { status_code, error in
                if let err = error {
                    print(err)
                } else {
                    if status_code == 1 || status_code == 12 {
                        self.isFavorite = true
                        dispatch_async(dispatch_get_main_queue()) {
                            self.toggleFavoriteButton.tintColor = nil
                        }
                    } else {
                        print("Unexpected status code \(status_code)")
                    }
                }
            }
        }
        // TODO: Add the movie to favorites, then update favorite button */
        print("implement me: MovieDetailViewController toggleFavoriteButtonTouchUp()")
        
    }
    
    @IBAction func toggleWatchlistButtonTouchUp(sender: AnyObject) {
        
        // TODO: Add the movie to watchlist, then update watchlist button */
        print("implement me: MovieDetailViewController toggleWatchlistButtonTouchUp()")
    }
}