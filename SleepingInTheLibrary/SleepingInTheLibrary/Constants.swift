//
//  Constants.swift
//  SleepingInTheLibrary
//
//  Created by Hyun on 2016. 2. 4..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation


struct Constants {
    
    struct FlickAPIKeyParams {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryId = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
    }
    
    struct FlickAPIValuesParams {
        static let methodValue = "flickr.galleries.getPhotos"
        static let APIKeyValue = "fc32b10bb0a2f30416fb38f74c18846a"
        static let gallerIdValue = "5704-72157622566655097"
        static let UrlValue = "url_m"
        static let FormatValue = "json"
        static let DisableJSONCallback = "1"
    }
    
    struct FlickAPIResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Total  = "total"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}