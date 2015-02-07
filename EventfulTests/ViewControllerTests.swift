//
//  ViewControllerTests.swift
//  Eventful
//
//  Created by Jacob Cho on 2015-01-31.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import UIKit
import XCTest
import Eventful

class ViewControllerTests: XCTestCase {
    // checkRadius
    // checkDates

    func positiveRadiusCheck() {
        
        let viewController = ViewController()
        let radius = "250.0"
        
        viewController.checkRadius(radius)
        
        XCTAssertTrue(viewController.validRadius, "Radius is valid")
    }
    
    func negativeRadiusCheck() {
        
        let viewController = ViewController()
        let radius = "-100.0"
        
        viewController.checkRadius(radius)
        
        XCTAssertFalse(viewController.validRadius, "Radius is less than zero")
        
    }
    
    func largeRadiusCheck() {
        
        let viewController = ViewController()
        let radius = "500.0"
        
        viewController.checkRadius(radius)
        
        XCTAssertFalse(viewController.validRadius, "Radius is greater than 300")
        
    }
    
    func numericRadiusCheck() {
        
        let viewController = ViewController()
        let radius = "asdfj)#*$"
        
        viewController.checkRadius(radius)
        
        XCTAssertFalse(viewController.validRadius, "Radius is not numeric")

    }
    
    func positiveDateCheck() {
        
        let startDate : NSString = "31/01/2015"
        let endDate : NSString = "22/02/2015"
        
        let viewController = ViewController()
        
        viewController.checkDates(startDate, endDateString: endDate)
        
        XCTAssertTrue(viewController.validDates, "Dates are valid")
        
    }
    
    func endBeforeStart() {
        
        let startDate : NSString = "31/01/2015"
        let endDate : NSString = "22/01/2015"
        
        let viewController = ViewController()
        
        viewController.checkDates(startDate, endDateString: endDate)
        
        XCTAssertFalse(viewController.validDates, "End date is before start date")
    }
    
    func startBeforeToday() {
        
        let startDate : NSString = "30/01/2015"
        let endDate : NSString = "22/02/2015"
        
        let viewController = ViewController()
        
        viewController.checkDates(startDate, endDateString: endDate)
        
        XCTAssertFalse(viewController.validDates, "Start date is before today's date")
        
    }
    
    func afterTwentyEight() {
        
        let startDate : NSString = "31/01/2015"
        let endDate : NSString = "22/06/2015"
        
        let viewController = ViewController()
        
        viewController.checkDates(startDate, endDateString: endDate)
        
        XCTAssertFalse(viewController.validDates, "End date is more than 28 days past the start date")
        
    }
    
    func afterOneYear() {
        
        let startDate : NSString = "31/01/2015"
        let endDate : NSString = "22/02/2016"
        
        let viewController = ViewController()
        
        viewController.checkDates(startDate, endDateString: endDate)
        
        XCTAssertFalse(viewController.validDates, "End date is more than one year past the start date")
        
    }
    
    func startDateInvalidFormat() {
        
        let startDate : NSString = "Jan 31, 2015"
        let endDate : NSString = "22/02/2015"
        
        let viewController = ViewController()
        
        viewController.checkDates(startDate, endDateString: endDate)
        
        XCTAssertFalse(viewController.validDates, "Start date not in the correct format")
        
    }
    
    func endDateInvalidFormat() {
        
        let startDate : NSString = "31/01/2015"
        let endDate : NSString = "02/22/2015"
        
        let viewController = ViewController()
        
        viewController.checkDates(startDate, endDateString: endDate)
        
        XCTAssertFalse(viewController.validDates, "End date not in the correct format")
        
    }
    

}
