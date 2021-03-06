//
//  NSDateFormatterExtension.swift
//  Eventful
//
//  Created by Jacob Cho on 2015-01-29.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import Foundation
import UIKit

extension NSDateFormatter {
    
    class func formatToShortStyle(date : NSDate) -> NSString {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB")
        
        return dateFormatter.stringFromDate(date)
    }
    
    class func dateFromShortStyleString(string : NSString) -> NSDate? {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB")
        
        return dateFormatter.dateFromString(string as! String)
    }
    
    class func dateFromEventful(string : NSString) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        return dateFormatter.dateFromString(string as! String)!
        
    }
    
    class func dateToCell(date : NSDate) -> NSString {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        
        return dateFormatter.stringFromDate(date)
        
    }


}
