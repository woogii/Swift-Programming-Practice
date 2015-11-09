//
//  ViewController.swift
//  HonoluluArt
//
//  Created by Hyun on 2015. 11. 9..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius:CLLocationDistance = 1000.0
    var artworks = [Artwork]()
      var locationManager = CLLocationManager()
    
    func loadInitialData() {
        // 1
        let fileName = NSBundle.mainBundle().pathForResource("PublicArt", ofType: "json");
        
        
        do  {
            // 1
            // Read the PublicArt.json file into an NSData object
            let data: NSData = try NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
            
            do {
                var error: NSError?
                // 2
                // Use NSJSONSerialization to obtain a JSON object
                let jsonObject: AnyObject! = try NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions(rawValue: 0))
                
                // 3
                // Check that the JSON object is a dictionary where the keys are Strings and the values can be AnyObject
                if let jsonObject = jsonObject as? [String: AnyObject] where error == nil,
                    // 4
                    // You’re only interested in the JSON object whose key is "data" and you loop through that array of arrays, checking that each element is an array
                    let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
                        for artworkJSON in jsonData {
                            if let artworkJSON = artworkJSON.array,
                                // 5
                                // Pass each artwork’s array to the fromJSON method that you just added to the Artwork class. If it returns a valid Artwork object, you append it to the artworks array.
                                artwork = Artwork.fromJSON(artworkJSON) {
                                    artworks.append(artwork)
                            }
                        }
                }
                
            } catch {
                
            }
        } catch {
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        //let artwork = Artwork(title:  "King David Kalakaua", locationName: "Waikiki Gateway Park", discipline: "Sculpture", coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        
        loadInitialData()
        mapView.addAnnotations(artworks)
        mapView.delegate = self
    }
    
    func centerMapOnLocation(location:CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2.0, regionRadius*2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - location manager to authorize user location for Maps app
  
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

}


