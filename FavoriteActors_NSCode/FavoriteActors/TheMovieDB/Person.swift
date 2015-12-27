//
//  Person.swift
//  TheMovieDB
//
//  Created by Jason on 1/11/15.
//

import UIKit

class Person : NSObject, NSCoding {
 
    struct Keys {
        static let Name = "name"
        static let ProfilePath = "profile_path"
        static let Movies = "movies"
        static let ID = "id"
    }
    
    var name = ""
    var id = 0
    var imagePath = ""
    var movies = [Movie]()
    
    init(dictionary: [String : AnyObject]) {
        name = dictionary[Keys.Name] as! String
        id = dictionary[TheMovieDB.Keys.ID] as! Int
        
        if let pathForImgage = dictionary[Keys.ProfilePath] as? String {
            imagePath = pathForImgage
        }
    }
    
    // MARK : - NSCoding 
    
    required init(coder decoder: NSCoder) {
        
//        guard let name = decoder.decodeObjectForKey("name") as? String,
//            let imagePath = decoder.decodeObjectForKey("imagePath") as? String
//            else { return nil }
//        
//        
//        let dictionary:[String:AnyObject] = [
//            "name" : name,
//            "id"   : decoder.decodeIntegerForKey("id"),
//            "imagePath" : imagePath
//        ]
//        
//        self.init(dictionary: dictionary)
        super.init()
        
        name = decoder.decodeObjectForKey(Keys.Name) as! String
        id = decoder.decodeIntegerForKey(Keys.ID)
        imagePath = decoder.decodeObjectForKey(Keys.ProfilePath) as! String
        movies = decoder.decodeObjectForKey(Keys.Movies) as! [Movie]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: Keys.Name)
        aCoder.encodeObject(imagePath, forKey: Keys.ProfilePath)
        aCoder.encodeInteger(id, forKey: Keys.ID)
        aCoder.encodeObject(movies, forKey: Keys.Movies)
    }
   
    /**
      image is a computed property. From outside of the class is should look like objects
      have a direct handle to their image. In fact, they store them in an imageCache. The
      cache stores the images into the documents directory, and keeps a resonable number of
      them in memory.
    */
    
    var image: UIImage? {
        get {
            return TheMovieDB.Caches.imageCache.imageWithIdentifier(imagePath)
        }
        
        set {
            TheMovieDB.Caches.imageCache.storeImage(image, withIdentifier: imagePath)
        }
    }
}


