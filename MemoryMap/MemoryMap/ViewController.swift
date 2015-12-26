//
//  ViewController.swift
//  MemoryMap
//
//  Created by Hyun on 2015. 12. 26..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    // MARK : - Properties
    @IBOutlet weak var mapView: MKMapView!
    
    // Computed property for acquiring file path
    var filePath : String {
        
        let fileManager = NSFileManager.defaultManager()
        let dirPath = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        return dirPath.URLByAppendingPathComponent("MapInfo").path!
    }
    
    // MARK : - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreMapRegion()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        
    }

    // MARK : - Helper method for saving coordinates of the map
    func saveMapRegion() {

       let dictionary = [
        "latitude" : mapView.region.center.latitude,
        "longitude" : mapView.region.center.longitude,
        "latitudeDelta" : mapView.region.span.latitudeDelta,
        "longitudeDelta" : mapView.region.span.longitudeDelta,
       ]

       NSKeyedArchiver.archiveRootObject(dictionary, toFile: filePath)
    }
    
    // MARK : - Helper method for restoring the saved coordinates of the map
    func restoreMapRegion() {
        
        
        if let regionInfo = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [String:AnyObject] {
            
            let latitude = regionInfo["latitude"] as! CLLocationDegrees
            let longitude = regionInfo["longitude"] as! CLLocationDegrees
            let latitudeDelta = regionInfo["latitudeDelta"] as! CLLocationDegrees
            let longitudeDelta = regionInfo["longitudeDelta"] as! CLLocationDegrees
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span   = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            
            let region = MKCoordinateRegion(center: center, span: span)
            
            
            mapView.setRegion(region, animated: true)
        }
    }


    // MARK : - MapviewDelegate Method
    
    // Tells the delegate that the region displayed by the map view just changed
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Viewcontroller is to be notified whenever the map region changed
        saveMapRegion()
    }
    
}

