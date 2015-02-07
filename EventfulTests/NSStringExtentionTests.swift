//
//  NSStringExtentionTests.swift
//  Eventful
//
//  Created by Jacob Cho on 2015-01-31.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import UIKit
import XCTest
import Eventful

class NSStringExtentionTests: XCTestCase {
    
    
    func addressConversion() {
        let string = "1152 Mainland St, Vancouver, BC"
        let addressToConvert = NSString.prepForJSON(string)
        let expected : NSString = "1152+Mainland+St+Vancouver+BC"
        
        XCTAssertEqual(addressToConvert, expected, "Strings are equal")
        
    }
    
    func dateRangePrep() {
        
        let startDate = "31/01/2015"
        let endDate = "12/02/2015"
        
        let convertedDates = NSString.prepDatesForJSON(startDate, endDate: endDate)
        
        var expected : NSString = "2015013100-2015021200"
        
        XCTAssertEqual(convertedDates, expected, "Dates converted successfully")
        
    }

}
