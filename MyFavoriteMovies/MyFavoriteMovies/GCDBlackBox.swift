//
//  GCDBlackBox.swift
//  MyFavoriteMovies
//
//  Created by Hyun on 2016. 2. 16..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: ()-> Void) {
    
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}