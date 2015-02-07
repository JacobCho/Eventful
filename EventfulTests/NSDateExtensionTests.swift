//
//  NSDateExtensionTests.swift
//  Eventful
//
//  Created by Jacob Cho on 2015-01-31.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import UIKit
import XCTest
import Eventful

class NSDateExtensionTests: XCTestCase {
    
    func giveMeFiveDays() {
        
        let today : NSString = "31/01/2015"
        if let date = NSDateFormatter.dateFromShortStyleString(today) {
            let fiveDaysLater = date.addDays(5)
            let shortStyle = NSDateFormatter.formatToShortStyle(fiveDaysLater)
            
            let expected : NSString = "05/02/2015"
            
            XCTAssertEqual(shortStyle, expected, "Successfully converted to 5 days later")
        }
    }
    
    func tenYearsLater() {
        
        let today : NSString = "31/01/2015"
        if let date = NSDateFormatter.dateFromShortStyleString(today) {
            let theFuture = date.addYears(10)
            let shortStyle = NSDateFormatter.formatToShortStyle(theFuture)
            
            let expected : NSString = "31/01/2025"
            
            XCTAssertEqual(shortStyle, expected, "We are in the future")
        }
    }

}
