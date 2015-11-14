//
//  TMDBConvenience.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit
import Foundation

// MARK: - TMDBClient (Convenient Resource Methods)

extension TMDBClient {
    
    
    // MARK: Authentication (GET) Methods
    /*
    Steps for Authentication...
    https://www.themoviedb.org/documentation/api/sessions
    
    Step 1: Create a new request token
    Step 2a: Ask the user for permission via the website
    Step 3: Create a session ID
    Bonus Step: Go ahead and get the user id 😎!
    */
    func authenticateWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* Chain completion handlers for each request so that they run one after the other */
        self.getRequestToken() { (success, requestToken, errorString) in
            
            if success {
                
                self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
                    
                    if success {
                        
                        self.getSessionID(requestToken!) { (success, sessionID, errorString) in
                            
                            if success {
                                self.sessionID = sessionID
                                
                                self.getUserID() { (success, userID, errorString) in
                                    
                                    if success {
                                        
                                        if let userID = userID {
                                            
                                            /* And the userID 😄! */
                                            self.userID = userID
                                        }
                                        
                                    }
                                    
                                    completionHandler(success: success, errorString: errorString)
                                    
                                }
                                
                            } else {
                                completionHandler(success: success, errorString: errorString)
                            }
                        }
                    } else {
                        completionHandler(success: success, errorString: errorString)
                    }
                }
                
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func getRequestToken(completionHandler: (success: Bool, requestToken: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        
        /* 2. Make the request */
        /* 3. Send the desired value(s) to completion handler */
        taskForGETMethod(Methods.AuthenticationTokenNew, parameters: parameters) {
                                (JSONResult, error) in
            if let error = error {
                print(error)
                completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token)")
            } else {
                if let requestToken =
                    JSONResult[TMDBClient.JSONResponseKeys.RequestToken] as? String {
                    completionHandler(success: true, requestToken: requestToken, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.RequestToken) in \(JSONResult)")
                    completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token)")
                }
            }
        }
    }
    
//    /* This function opens a TMDBAuthViewController to handle Step 2a of the auth flow */
   func loginWithToken(requestToken: String?, hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
    
        let authorizationURL = NSURL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)")
        let request = NSURLRequest(URL: authorizationURL!)
        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("TMDBAuthViewController") as! TMDBAuthViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.requestToken = requestToken
        webAuthViewController.completionHandler = completionHandler
    
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
    
        dispatch_async(dispatch_get_main_queue(), {
            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
        })
    }
    
    func getSessionID(requestToken: String, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void ) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [
            TMDBClient.ParameterKeys.RequestToken: requestToken
        ]
        
        /* 2. Make the request */
        taskForGETMethod(Methods.AuthenticationSessionNew, parameters: parameters) {  JSONResult, error in
            
            if let error = error {
                print(error)
                completionHandler(success: false, sessionID: nil, errorString: "Login Failed (SessionID)")
            } else {
                if let sessionID = JSONResult[TMDBClient.JSONResponseKeys.SessionID] as? String {
                    
                    completionHandler(success: true, sessionID: sessionID, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                    completionHandler(success: false, sessionID: nil, errorString: "Login Failed (SessionID)")
                }
            }
        }
    }
    
    func getUserID(completionHandler:(success:Bool, userId:Int?, errorString: String?)->Void ) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [
            TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!
        ]
        
        /* 2. Make the request */
        taskForGETMethod(Methods.Account, parameters: parameters) {  (JSONResult, error) in
            
            if let error = error {
                print(error)
                completionHandler(success: false, userId: nil, errorString: "Login Failed (User ID).")
            } else {
                if let userID = JSONResult[TMDBClient.JSONResponseKeys.UserID] as? Int {
                    completionHandler(success: true, userId: userID, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                    completionHandler(success: false, userId: nil, errorString: "Login Failed (userID)")
                }
            }
        }
    }
    
    // MARK: GET Convenience Methods
    
    func getFavoriteMovies(completionHandler: (result: [TMDBMovie]?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.SessionID: TMDBClient.sharedInstance().sessionID!]
        var mutableMethod : String = Methods.AccountIDFavoriteMovies
        mutableMethod = TMDBClient.subtituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult[TMDBClient.JSONResponseKeys.MovieResults] as? [[String : AnyObject]] {
                    
                    let movies = TMDBMovie.moviesFromResults(results)
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }

    
    func getWatchlistMovies(completionHandler: (result: [TMDBMovie]?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        /* 2. Make the request */
        /* 3. Send the desired value(s) to completion handler */
        
        let parameters =  [
            TMDBClient.ParameterKeys.SessionID : sessionID!
        ]
        
        // "account/{id}/watchlist/movies"
        let method = TMDBClient.subtituteKeyInMethod(Methods.AccountIDWatchlistMovies, key: "id", value: "\(self.userID)")
        
        taskForGETMethod(method! , parameters: parameters, completionHandler: {
            (JSONResult, error) in
            
            if let error = error {
                print(error)
                completionHandler(result: nil, error: error)
            }
            else {
                if let list = JSONResult["results"] as? [[String:AnyObject]] {
                    let result = TMDBMovie.moviesFromResults(list)
                    completionHandler(result: result, error:nil)
                }
                else {
                    print("Could not find \(TMDBClient.JSONBodyKeys.Watchlist) in \(JSONResult)")
                    completionHandler(result: nil, error: error)
                }
            }
        })
    }
    
    func getMoviesForSearchString(searchString: String, completionHandler: (result: [TMDBMovie]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.Query: searchString]
        
        /* 2. Make the request */
        let task = taskForGETMethod(Methods.SearchMovie, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult[TMDBClient.JSONResponseKeys.MovieResults] as? [[String : AnyObject]] {
                    
                    let movies = TMDBMovie.moviesFromResults(results)
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        
        return task
    }

    func getConfig(completionHandler: (didSucceed: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        
        /* 2. Make the request */
        taskForGETMethod(Methods.Config, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(didSucceed: false, error: error)
            } else if let newConfig = TMDBConfig(dictionary: JSONResult as! [String : AnyObject]) {
                self.config = newConfig
                completionHandler(didSucceed: true, error: nil)
            } else {
                completionHandler(didSucceed: false, error: NSError(domain: "getConfig parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getConfig"]))
            }
        }
    }

}