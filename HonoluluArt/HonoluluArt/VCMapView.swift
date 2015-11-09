//
//  VCMapView.swift
//  HonoluluArt
//
//  Created by Hyun on 2015. 11. 9..
//  Copyright © 2015년 wook2. All rights reserved.
//

import Foundation
import MapKit

extension ViewController : MKMapViewDelegate {
    
    // mapView(_:viewForAnnotation:) is the method that gets called for every annotation you add to the map
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation)->MKAnnotationView? {
        
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view : MKPinAnnotationView
            
           // map views are set up to 'reuse' annotation views when some are no longer visible
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! MKPinAnnotationView? {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // if an annotation view could not be dequeued
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type:.DetailDisclosure) as UIView
                
            }
            
           
            switch annotation.discipline {
                
                case "Sculpture", "Plaque":
                    view.pinTintColor = UIColor.redColor()
                case "Mural", "Monument":
                    view.pinTintColor = UIColor.purpleColor()
                default:
                    view.pinTintColor = UIColor.greenColor()
                
            }
            
            return view
        }
        return nil
    }
    
    // mapView(_:annotationView:calloutAccessoryControlTapped:) method is called when the user
    // taps this info button
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
        
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
}

// Note: When you dequeue a reusable annotation, you give it an identifier. If you have multiple styles of annotations, be sure to have a unique identifier for each one, otherwise you might mistakenly dequeue an identifier of a different type, and have unexpected behavior in your app. It’s basically the same idea behind a cell identifier in tableView(_:cellForRowAtIndexPath:).