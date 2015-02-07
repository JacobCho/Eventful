//
//  NSDateFormatterTests.swift
//  Eventful
//
//  Created by Jacob Cho on 2015-01-31.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import UIKit
import XCTest
import Eventful

class NSDateFormatterTests: XCTestCase {
    
    
    func shortStyleDateConversion() {
        
        let todaysDate : NSString = "31/01/2015"
        if let converted = NSDateFormatter.dateFromShortStyleString(todaysDate) {
       
            let backAgain : NSString = NSDateFormatter.formatToShortStyle(converted)
            
            XCTAssertEqual(todaysDate, backAgain, "Both dates are equal")
        }
        
    }
    
    func dateConversionFail() {
        
        let USToday : NSString = "01/31/2015"
        let converted : NSDate = NSDateFormatter.dateFromShortStyleString(USToday)!
        
        XCTAssertNil(converted, "Converted date should be nil")
        
    }
    
    func dateFromEventful() {
        let dateToConvert : NSString = "2015-01-31 13:31:00"
        let converted = NSDateFormatter.dateFromEventful(dateToConvert)
        let stringToDisplay : NSString = NSDateFormatter.dateToCell(converted)
        
        let expected : NSString = "01/31/15, Saturday"
        
        XCTAssertEqual(stringToDisplay, expected, "Date converted successfully")
        
    }

}
