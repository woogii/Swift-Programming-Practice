//
//  GCDBlackBox.swift
//  FlickFinder
//
//  Created by Hyun on 2016. 2. 4..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

func perfromUIUpdatesOnMain(updates:() -> Void) {
    
    dispatch_async(dispatch_get_main_queue()){
        updates()
    }
}