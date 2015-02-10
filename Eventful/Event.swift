//
//  Event.swift
//  Eventful
//
//  Created by Jacob Cho on 2015-01-27.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import UIKit

enum Category {
    case Music
    case Sports
    case PerformingArts
}

class Event: NSObject {
    
    var title : NSString
    var venue : NSString
    var date : NSString
    var performers : [String]?
    var imageURL : NSString?
    var image : UIImage?
    var type : Category?
    var latitude : NSString?
    var longitude : NSString?
    
    init(title : NSString, venue : NSString, date: NSString) {
        self.title = title
        self.venue = venue
        self.date = date
    }
    
}

