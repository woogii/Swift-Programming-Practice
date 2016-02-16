//
//  Constants.swift
//  MyFavoriteMovies
//
//  Created by Hyun on 2016. 2. 12..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation


struct TMDBConstants {
    
    struct TMDB {
        static let APIScheme = "https"
        static let APIHost = "api.themoviedb.org"
        static let APIPath = "/3/"
        static let APIAuthTokenNew = "/authentication/token/new"
        static let APIValidateLogin = "/authentication/token/validate_with_login"
        static let APISessionNew = "/authentication/session/new"
    }
    
    struct TMDBParamKeys{
        static let APIKey = "api_key"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
        
    struct TMDBResponseKeys {
        static let Success = "success"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
    }
    
    struct Selectors {
        static let KeyboardWillShow:Selector = "keyboardWillShow:"
        static let KeyboardWillHide:Selector = "keyboardWillHide:"
    }
    
    
}