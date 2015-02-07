//
//  NSStringExtension.swift
//  Eventful
//
//  Created by Jacob Cho on 2015-01-28.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import Foundation
import UIKit

extension NSString {
    
    class func prepForJSON(string: NSString) -> NSString {
        let noCommas = string.stringByReplacingOccurrencesOfString(",", withString: "")
        let noSpaces = noCommas.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
       return noSpaces
    }
    
    class func prepDatesForJSON(startDate : NSString, endDate : NSString) -> NSString {
        var start = NSDateFormatter.dateFromShortStyleString(startDate)
        var end = NSDateFormatter.dateFromShortStyleString(endDate)
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        
        var startString = dateFormatter.stringFromDate(start!)
        var endString = dateFormatter.stringFromDate(end!)
        
        return startString + "00" + "-" + endString + "00"
    }
    
    
}