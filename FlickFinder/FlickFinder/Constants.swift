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
        static let APIHost =   "api.flickr.com"
        static let APIPath =   "/services/rest"
    }
    
    struct FlickrAPIParamKeys {
        static let APIKey = "api_key"
        static let Method = "method"
        static let Text =   "text"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
    }
    
    struct FlickrAPIParamValues {
        static let APIKeyValue = "725c46bd47f3f0acc79e990bb7b5e451"
        static let MethodValue = "flickr.photos.search"
        static let TextValue = ""
        static let UrlValue = "url_m"
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