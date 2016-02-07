//
//  Constants.swift
//  FlickFinder
//
//  Created by Hyun on 2016. 2. 4..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation


struct Constants {

    struct FlickrAPI {
        static let BaseURL = "https://api.flickr.com/services/rest/"
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    struct FlickrAPIParamKeys {
        static let APIKey = "api_key"
        static let Method = "method"
        static let Text   = "text"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let BoundingBox = "bbox"
        static let Page = "page"
    }
    
    struct FlickrAPIParamValues {
        static let APIKeyValue = "69fe584654e9e999a3d65547f9675342"
        static let MethodValue = "flickr.photos.search"
        static let TextValue = ""
        static let BBoxValue = ""
        static let UseSafeSearch = "1"
        static let MediumURL = "url_m"
        static let FormatValue = "json"
        static let DisableJSONCallback = "1"
        
    }
    
    struct FlickrAPIResponseKeys {
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    struct FlickrAPIResponseValues {
        static let OKStatus = "ok"
    }
    
}