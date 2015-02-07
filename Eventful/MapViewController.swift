//
//  MapViewController.swift
//  Eventful
//
//  Created by Jacob Cho on 2015-02-02.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var event : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self

        self.setupMap()
    
    }
    
    func setupMap() {
        if let mapEvent = self.event {
            var lat = CLLocationDegrees(mapEvent.latitude!.doubleValue)
            var long = CLLocationDegrees(mapEvent.longitude!.doubleValue)
            
            let startingLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            var span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            var region = MKCoordinateRegion(center: startingLocation, span: span)
            
            self.mapView.setRegion(region, animated: true)
            
            self.setupMarker(startingLocation, event: mapEvent)
            
        }
        
    }
    
    func setupMarker(location : CLLocationCoordinate2D, event : Event) {
        
        var marker = EventMarker(coordinate: location, title: event.title, subtitle: event.venue)
        
        self.mapView.addAnnotation(marker)
    }
}
