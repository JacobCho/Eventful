//
//  ViewController.swift
//  Eventful
//
//  Created by Jacob Cho on 2015-01-27.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import UIKit

struct APIStrings {
    
    // Eventful API URL Strings
    static let EFApiRoot = "http://api.eventful.com/json/events/search?"
    static let EFApiKey = "app_key=cSb6h8MsvpCVb3TF"
    static let EFKeywordMethod = "&keywords="
    static let EFLocationMethod = "&location="
    static let EFDateMethod = "&date="
    static let EFWithinMethod = "&within="
    static let EFSortOrderMethod = "&sort_order="
    static let EFPageSizeMethod = "&page_size="
    
    // Google Geocoding API URL Strings
    static let GGApiRoot = "https://maps.googleapis.com/maps/api/geocode/json?"
    static let GGApiKey = "&key=AIzaSyByvqGV_IrWboTFKbFcM6jsGSI6iSSoOnc"
    static let GGAddressMethod = "address="
    
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    
    @IBOutlet weak var addressErrorLabel: UILabel!
    @IBOutlet weak var radiusErrorLabel: UILabel!
    @IBOutlet weak var dateErrorLabel: UILabel!
    
    var validAddress = false
    var validRadius = true
    var validDates = true
    
    var eventsArray : [Event] = []
    var addressCoordinates : String?
    let categoryPickerArray = ["Music", "Sports", "Performing Arts"]
    let today = NSDate()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressTextField.delegate = self
        self.radiusTextField.delegate = self
        self.startDateTextField.delegate = self
        self.endDateTextField.delegate = self
        
        self.startDateTextField.text = NSDateFormatter.formatToShortStyle(today) as! String
        self.endDateTextField.text = NSDateFormatter.formatToShortStyle(today.addDays(1)) as! String
        
    }
    

    @IBAction func startDateButtonPressed(sender: UIButton) {
        self.setupDatePicker(sender)
    }

    @IBAction func endDateButtonPressed(sender: UIButton) {
        self.setupDatePicker(sender)
    }

    @IBAction func categoryButtonPressed(sender: UIButton) {
        self.setupCategoryPicker(sender)
    }
    
    @IBAction func searchButtonPressed(sender: UIButton) {
        
        // Clear eventsArray
        self.eventsArray.removeAll(keepCapacity: true)
        
        var category = self.categoryTextField.text.stringByReplacingOccurrencesOfString(" ", withString:"")
        
        var urlString = APIStrings.EFApiRoot + APIStrings.EFApiKey +
                APIStrings.EFKeywordMethod + category +
                APIStrings.EFLocationMethod + self.addressCoordinates! +
                APIStrings.EFWithinMethod + self.radiusTextField.text +
                APIStrings.EFDateMethod +
            NSString.prepDatesForJSON(self.startDateTextField.text, endDate: self.endDateTextField.text) +
                APIStrings.EFSortOrderMethod + "popularity" + APIStrings.EFPageSizeMethod + "50"
        
        let url = NSURL(string: urlString)
        
        self.getEventsInBackground(url!)
    }
    
    
    // MARK: Networking Methods 
    
    func getEventsInBackground(url : NSURL) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url, options: nil, error: nil)
            var jsonError : NSError?
            if let dataDictionary : NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError) as? NSDictionary {
                if let eventsDictionary = dataDictionary["events"] as? NSDictionary {
                    if let eventsList = eventsDictionary["event"] as? NSArray {
                        for event in eventsList {
                            var newEvent = Event(title: event["title"] as! NSString,
                                venue: event["venue_name"] as! NSString,
                                date: event["start_time"] as! NSString)
                            newEvent.latitude = event["latitude"] as? NSString
                            newEvent.longitude = event["longitude"] as? NSString
                            
                            if let images = event["image"] as? NSDictionary {
                                if let medSize = images["medium"] as? NSDictionary {
                                    newEvent.imageURL = medSize["url"] as? NSString
                                }
                            }
                            
                            if let performers = event["performers"] as? NSDictionary {
                                newEvent.performers = []
                                if let performersArray = performers["performer"] as? NSArray {
                                    for performer in performersArray {
                                        newEvent.performers?.append(performer["name"] as! String)
                                    }
                                }
                                if let performer = performers["performer"] as? NSDictionary {
                                    newEvent.performers?.append(performer["name"] as! String)
                                }
                            }
                            
                            self.eventsArray.append(newEvent)
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.eventsArray.sort({ $0.date < $1.date as String})

                    self.tableView.reloadData()
                }
            
            
            } else {
                if let error = jsonError {
                    println(error)
                }
                
            }
        }
        
    }
    
    func loadImageInBackground(event : Event, cell : EventTableViewCell) {
        let url = NSURL(string: event.imageURL! as! String)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!, options: nil, error: nil)
            
            dispatch_async(dispatch_get_main_queue()) {
                cell.eventImageView.image = UIImage(data: data!)
                event.image = UIImage(data: data!)
            }
        }
        
    }
    
    func getGeocodeInBackground(address : NSString) {
        var lat : Double?
        var lng : Double?
        let urlString = APIStrings.GGApiRoot + APIStrings.GGAddressMethod + NSString.prepForJSON(address) + APIStrings.GGApiKey
        let url = NSURL(string: urlString)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!, options: nil, error: nil)
            var jsonError : NSError?
            if let dataDictionary : NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError) as? NSDictionary {
                if let locationArray = dataDictionary["results"] as? NSArray {
                    if locationArray.count > 0 {
                        let firstResult : NSDictionary = locationArray[0] as! NSDictionary
                        if let geometry = firstResult["geometry"] as? NSDictionary {
                            if let location = geometry["location"] as? NSDictionary {
                                lat = location["lat"] as? Double
                                lng = location["lng"] as? Double
                                if let latitude = lat, longitude = lng {
                                    self.addressCoordinates = String(stringInterpolationSegment: latitude) + "," + String(stringInterpolationSegment: longitude)
                                    
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.validAddress = true
                                        self.checkAllValid()
                                        self.addressErrorLabel.alpha = 0
                                    }
                                }
                            }
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                        // No location results
                        self.validAddress = false
                        self.checkAllValid()
                        self.addressErrorLabel.alpha = 1
                        }
                    }
                }
                
            }
            else {
                if let error = jsonError {
                    self.validAddress = false
                    self.checkAllValid()
                    self.addressErrorLabel.alpha = 1
                    println(error)
                }
                
            }

        }
        
    }
    
    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       let mapViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        mapViewController.event = self.eventsArray[indexPath.row]
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : EventTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
        
        // Reset image 
        cell.eventImageView.image = nil
        
        let event = eventsArray[indexPath.row]
        cell.titleLabel.text = event.title as! String
        cell.venueLabel.text = event.venue as! String
        var eventDate = NSDateFormatter.dateFromEventful(event.date)
        cell.dateLabel.text = NSDateFormatter.dateToCell(eventDate) as! String
        
        
        // If the event has an image, load in background
        if let imageURL = event.imageURL {
            if let image = event.image {
                cell.eventImageView.image = image
            } else {
                self.loadImageInBackground(event, cell: cell)
            }
        }
        
        // If event has a performers list, add to label
        if let performers = event.performers {
            var performersList : String = ""
            if performers.count == 1 {
                performersList = performers[0]
            } else {
                for performer in performers {
                    if performer == performers.last {
                        performersList = (performersList + performer)
                    } else {
                        performersList = (performersList + performer) + ", "
                    }
                }
            }
            cell.performersLabel.text = performersList as! String
        } else {
            cell.performersLabel.text = ""
        }
        
        return cell
        
    }
    
    // MARK: UITextfield Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }
    
    // If user touches outside the keyboard, resign keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        if textField == self.addressTextField {
            if self.addressTextField.text.isEmpty {
                
            } else {
                self.getGeocodeInBackground(self.addressTextField.text)
            }

        }
        
        if textField == self.radiusTextField {
            self.checkRadius(self.radiusTextField.text)
            self.checkAllValid()
        }
        
        if textField == self.startDateTextField || textField == self.endDateTextField {
            self.checkDates(self.startDateTextField.text, endDateString: self.endDateTextField.text)
            self.checkAllValid()
        }
        
        return true
    }
    
    // MARK: UIPickerDataSource Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categoryPickerArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return categoryPickerArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

    
    // MARK: Helper Methods
    func checkAllValid() {
        let validSearchArray = [self.validAddress, self.validRadius, self.validDates]
        var allValid = true
        for valid in validSearchArray {
            if valid as Bool == false {
                allValid = false
                self.disableSearchButton()
            }
        }
        if allValid == true {
            self.enableSearchButton()
        }
        
    }
    
    func disableSearchButton() {
        self.searchButton.enabled = false
        self.searchButton.backgroundColor = UIColor.grayColor()
    }
    
    func enableSearchButton() {
        self.searchButton.enabled = true
        self.searchButton.backgroundColor = UIColor.blueColor()
    }
    
    func checkRadius(radius : NSString) {
        
        let numSet = NSCharacterSet.alphanumericCharacterSet()
        let stringSet = NSCharacterSet(charactersInString: radius as! String)
        // Check if string is alphanumeric
        if numSet.isSupersetOfSet(stringSet) {
            
            var radFltValue = radius.floatValue
            
            if radFltValue < 0 || radFltValue > 300 {
                self.validRadius = false
                self.checkAllValid()
                self.radiusErrorLabel.alpha = 1.0
                
            } else {
                if !self.searchButton.enabled {
                    self.radiusErrorLabel.alpha = 0.0
                    self.validRadius = true
                    self.checkAllValid()
                }
        
            }
            
        } else {
            // String is not alphanumeric
            self.validRadius = false
            self.checkAllValid()
        }
        
    }
    
    func setupDatePicker(sender : UIButton) {
        var datePickerAlert = UIAlertController(title: "Pick a date", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .ActionSheet)
        var datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 20, datePickerAlert.view.bounds.width - 50, 100))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.minimumDate = today
        datePickerAlert.view.addSubview(datePickerView)
        
        let selectAction = UIAlertAction(title: "Select", style: .Default) { (action: UIAlertAction!) -> Void in
            var date = datePickerView.date
            
            if sender == self.startDateButton {
                self.startDateTextField.text = NSDateFormatter.formatToShortStyle(date) as! String
            } else {
                self.endDateTextField.text = NSDateFormatter.formatToShortStyle(date) as! String
            }
            
            self.checkDates(self.startDateTextField.text, endDateString: self.endDateTextField.text)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        datePickerAlert.addAction(selectAction)
        datePickerAlert.addAction(cancelAction)
        
        self.presentViewController(datePickerAlert, animated: true, completion: nil)
        
    }
    
    func setupCategoryPicker(sender : UIButton) {
        var categoryPickerAlert = UIAlertController(title: "Pick a category", message: "\n\n\n\n\n\n\n", preferredStyle: .ActionSheet)
        var picker : UIPickerView = UIPickerView(frame: CGRectMake(15, 20, categoryPickerAlert.view.bounds.width - 50, 80))
        
        picker.delegate = self
        picker.dataSource = self
        
        picker.showsSelectionIndicator = true
        picker.selectRow(0, inComponent: 0, animated: false)
        
        categoryPickerAlert.view.addSubview(picker)
        
        let selectAction = UIAlertAction(title: "Select", style: .Default) { (action: UIAlertAction!) -> Void in
            var row = picker.selectedRowInComponent(0)
            self.categoryTextField.text = self.categoryPickerArray[row]
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        categoryPickerAlert.addAction(selectAction)
        categoryPickerAlert.addAction(cancelAction)
        self.presentViewController(categoryPickerAlert, animated: true, completion: nil)
    }
    
    func checkDates(startDateString : NSString, endDateString : NSString) {
        
        if let start = NSDateFormatter.dateFromShortStyleString(startDateString) {
            
            if let end = NSDateFormatter.dateFromShortStyleString(endDateString) {

                if start.compare(end) == NSComparisonResult.OrderedDescending // If end date is before start
                    ||
                   start.compare(today) == NSComparisonResult.OrderedDescending // If start date is before today
                    ||
                   end.compare(today.addDays(28)) == NSComparisonResult.OrderedDescending // If end date is 28 days after today
                    ||
                   end.compare(today.addYears(1)) == NSComparisonResult.OrderedDescending // If end date is further than one year away from today
                {
                    self.dateErrorLabel.alpha = 1.0
                    self.validDates = false

                }
                    
                else {
                    
                    self.dateErrorLabel.alpha = 0.0
                    self.validDates = true

                }
                
            } else {
                // End date has invalid format or valid day of the month
                self.validDates = false
                self.dateErrorLabel.alpha = 1.0
                println("End date invalid format")
            }
        } else {
            // Start date has invalid format or valid day of the month
            self.validDates = false
            self.dateErrorLabel.alpha = 1.0
            println("Start date invalid format")
        }
        
    }


}

