//
//  EventMarker.swift
//  Eventful
//
//  Created by Jacob Cho on 2015-02-02.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import UIKit
import MapKit

class EventMarker: NSObject, MKAnnotation {
    
    var coordinate : CLLocationCoordinate2D
    var title : NSString
    var subtitle : NSString
    
    init(coordinate: CLLocationCoordinate2D, title : NSString, subtitle : NSString) {
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }

}
