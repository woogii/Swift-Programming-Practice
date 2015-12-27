//
//  Movie.swift
//  TheMovieDB
//
//  Created by Jason on 1/11/15.
//

import UIKit

class Movie : NSObject, NSCoding {
    
    struct Keys {
        static let Title = "title"
        static let PosterPath = "poster_path"
        static let ReleaseDate = "release_date"
    }
    
    var title = ""
    var id = 0
    var posterPath: String? = nil
    var releaseDate: NSDate? = nil
        
    init(dictionary: [String : AnyObject]) {
        title = dictionary[Keys.Title] as! String
        id = dictionary[TheMovieDB.Keys.ID] as! Int
        posterPath = dictionary[Keys.PosterPath] as? String
        
        if let releaseDateString = dictionary[Keys.ReleaseDate] as? String {
            releaseDate = TheMovieDB.sharedDateFormatter.dateFromString(releaseDateString)
        }
    }
    
    required init(coder decoder: NSCoder) {
    
        super.init()
        
        id = decoder.decodeIntegerForKey(TheMovieDB.Keys.ID)
        title = decoder.decodeObjectForKey(Keys.Title) as! String
        posterPath = decoder.decodeObjectForKey(Keys.PosterPath) as? String
        releaseDate = decoder.decodeObjectForKey(Keys.ReleaseDate) as? NSDate
        
        
//        let dictionary : [String: AnyObject] =  [
//            "title" : title,
//            "id" : decoder.decodeIntegerForKey("id") ,
//            "posterPath" : posterPath,
//            "releaseDate" : releaseDate
//        ]
        
        //self.init(dictionary:dictionary)
        
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(posterPath, forKey: "poster_path")
        aCoder.encodeObject(releaseDate, forKey: "release_date")
        aCoder.encodeInteger(id, forKey: "id")
    }
    
    /**
        posterImage is a computed property. From outside of the class is should look like objects
        have a direct handle to their image. In fact, they store them in an imageCache. The
        cache stores the images into the documents directory, and keeps a resonable number of
        them in memory.
    */
    
    var posterImage: UIImage? {
        
        get {
            return TheMovieDB.Caches.imageCache.imageWithIdentifier(posterPath)
        }
        
        set {
            TheMovieDB.Caches.imageCache.storeImage(newValue, withIdentifier: posterPath!)
        }
    }
}



