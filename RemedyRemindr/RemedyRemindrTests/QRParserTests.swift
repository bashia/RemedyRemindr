//
//  QRParserTests.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr on 2015-03-26.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit
import XCTest

class QRParserTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Test adding a medication without reminders
    func testMedicationWithoutReminders() {
        let medication = Medication(name : "Warfarin")
        let json = createJSON(medication)
        
        test(json, expected: medication)
    }
    
    // Test a start date that is before the current time
    func testStartDateBeforeNow () {
        let medication = Medication(name : "Warfarin")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (-6)), sinceDate: NSDate())
        let end = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (20)), sinceDate: NSDate())
        let reminder = createWeeklyReminder(start, end: end, times: [400, 900], days: 85)
        medication.reminders.append(reminder)

        let json = createJSON(medication)
        reminder.setStartDate(NSDate())
        
        test(json, expected: medication)
    }
    
    // Test a start date that is after the current time
    func testStartDateAfterNow () {
        let medication = Medication(name : "Warfarin")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let end = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (30)), sinceDate: NSDate())
        let reminder = createWeeklyReminder(start, end: end, times: [400, 900], days: 85)
        medication.reminders.append(reminder)
        
        let json = createJSON(medication)
        test(json, expected: medication)
    }
    
    // Test multiple reminders
    func testMultipleReminders() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let end = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (30)), sinceDate: NSDate())
        let remindera = createCustomReminder(start, end: end, times: [400, 900], days: 2)
        let reminderb = createSingleDayReminder(NSDate(timeInterval: NSTimeInterval(1440 * 60 * (2)), sinceDate: NSDate()), times: [467])
        
        medication.reminders.append(remindera)
        medication.reminders.append(reminderb)
        
        let json = createJSON(medication)
        test(json, expected: medication)
    }
    
    // Test enddate before startdate 
    func testEndDateBeforeStartDate() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let end = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (-30)), sinceDate: NSDate())
        let reminder = createCustomReminder(start, end: end, times: [400, 900], days: 2)
        
        medication.reminders.append(reminder)
        
        let json = createJSON(medication)
        test(json, expected: nil)
    
    }
    
    // Test enddate same as startdate
    func testEndDateEqualStartDate() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let reminder = createCustomReminder(start, end: start, times: [400, 900], days: 2)
        
        medication.reminders.append(reminder)
        
        let json = createJSONForceEndDate(medication)
        test(json, expected: nil)
    }
    
    // No repeat with end date
    func testRepeatWithEndDate() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let end = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (30)), sinceDate: NSDate())
        let reminder = createSingleDayReminder(start, times: [467])
        reminder.setEndDate(end)
        
        medication.reminders.append(reminder)
        
        let json = createJSON(medication)
        test(json, expected: nil)
    }
    
    // No repeat with days
    func testRepeatWithDays() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let reminder = createSingleDayReminder(start, times: [467])
        reminder.setDays(4)
        
        medication.reminders.append(reminder)
        
        let json = createJSONForceDays(medication)
        test(json, expected: nil)
    }
    
    // No times specified
    func testNoTimesSpecified() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let reminder = createSingleDayReminder(start, times: [])
        
        medication.reminders.append(reminder)
        
        let json = createJSON(medication)
        test(json, expected: nil)
    
    }
    
    // Times out of bounds
    func testTimesOutOfBounds() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let reminder = createSingleDayReminder(start, times: [-1])
        
        medication.reminders.append(reminder)
        
        var json = createJSON(medication)
        test(json, expected: nil)
    
        reminder.setTimes([1441])
        json = createJSON(medication)
        test(json, expected: nil)
    }
    
    // Invalid days value
    func testRepeatingWithInvalidDays() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let end = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (30)), sinceDate: NSDate())
        let reminder = createCustomReminder(start, end: end, times: [400, 900], days: 0)
        
        medication.reminders.append(reminder)
        
        let json = createJSON(medication)
        test(json, expected: nil)
    }
    
    // Test weekly with no days value specified
    func testWeeklyWithoutDays() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let end = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (30)), sinceDate: NSDate())
        let reminder = createWeeklyReminder(start, end: end, times: [400, 900], days: 85)
        
        medication.reminders.append(reminder)
        
        let json = createJSONForceNoDays(medication)
        test(json, expected: nil)
    }
    
    // Test custom with no days value specified
    func testCustomWithoutDays() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let end = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (30)), sinceDate: NSDate())
        let reminder = createCustomReminder(start, end: end, times: [400, 900], days: 2)
        
        medication.reminders.append(reminder)
        
        let json = createJSONForceNoDays(medication)
        test(json, expected: nil)
    }
    
    // Test reminder with no start date
    func testReminderWithNoStart() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let end = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (30)), sinceDate: NSDate())
        let reminder = createCustomReminder(start, end: end, times: [400, 900], days: 2)
        
        medication.reminders.append(reminder)
        
        let json = createJSONForceNoStart(medication)
        
        medication.reminders = []
        test(json, expected: medication)
    }
    
    // Test medication with no name
    func testMedicationWithNoName() {
        let medication = Medication(name : "Lipitor")
        let start = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (10)), sinceDate: NSDate())
        let end = NSDate(timeInterval: NSTimeInterval(1440 * 60 * (30)), sinceDate: NSDate())
        let reminder = createCustomReminder(start, end: end, times: [400, 900], days: 2)
        
        medication.reminders.append(reminder)
        
        let json = createJSONForceNoName(medication)
        test(json, expected: nil)
    }
    
    func test(inputJSON: String, expected: Medication?) {
    
        let qr: QRCaptureViewController =  QRCaptureViewController()
        let actual : Medication? = qr.qrJSONParse(inputJSON)
        
        
        if expected == nil {
            XCTAssertNil(actual, "Expected a nil return value")
        }
        else {
            
            if actual == nil {
                XCTAssertFalse(true, "Returned medication was nil")
                return
            }
            
            XCTAssertEqual(expected!.name, actual!.name, "The medicaiton name was incorrect")
            
            XCTAssertEqual(expected!.reminders.count, actual!.reminders.count, "The number of reminders was incorrect")
            
            for (var i = 0; i < expected!.reminders.count; i++) {
                XCTAssertEqual(expected!.reminders[i].toString(), actual!.reminders[i].toString(), "The reminders were not equal")
            }
        }
    }
    
    func createJSON(medication : Medication) -> String {
        return createJSON(medication, forceEndDate:false, forceDays:false, forceNoDays:false, forceNoStart:false, forceNoName:false)
    }
    
    func createJSONForceEndDate(medication : Medication) -> String {
        return createJSON(medication, forceEndDate:true, forceDays:false, forceNoDays:false, forceNoStart:false, forceNoName:false)
    }
    
    
    func createJSONForceDays(medication : Medication) -> String {
        return createJSON(medication, forceEndDate:false, forceDays:true, forceNoDays:false, forceNoStart:false, forceNoName:false)
    }
    
    func createJSONForceNoDays(medication : Medication) -> String {
        return createJSON(medication, forceEndDate:false, forceDays:false, forceNoDays:true, forceNoStart:false, forceNoName:false)
    }
    
    func createJSONForceNoStart(medication : Medication) -> String {
        return createJSON(medication, forceEndDate:false, forceDays:false, forceNoDays:false, forceNoStart:true, forceNoName:false)
    }
    
    func createJSONForceNoName(medication : Medication) -> String {
        return createJSON(medication, forceEndDate:false, forceDays:false, forceNoDays:false, forceNoStart:false, forceNoName:true)
    }
    
    func createJSON(medication : Medication, forceEndDate:Bool, forceDays:Bool, forceNoDays:Bool, forceNoStart:Bool, forceNoName:Bool) -> String {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        

        var json : String = "{"
        
        // Append medication name
        
        if !forceNoName {
             json += "\"n\":\"" + medication.name + "\","
        }
        
        // Check reminders
        json += "\"r\":["
        
        for reminder in medication.reminders {
            
            json += "{"
            if !forceNoStart {
                let startdate = dateFormatter.stringFromDate(reminder.getStartDate())
                json += "\"s\":\"" + startdate + "\","
            }
            
            if reminder.getStartDate().compare(reminder.getEndDate()) != .OrderedSame || forceEndDate {
                let enddate = dateFormatter.stringFromDate(reminder.getEndDate())
                json += "\"e\":\"" + enddate + "\","
            }
            
            json += "\"r\":\""
            switch(reminder.getRepeat()) {
            case Repeat.NO:
                json += "n"
                
            case Repeat.YES_CUSTOM:
                json += "c"
                
            case Repeat.YES_WEEKLY:
                json += "w"
            }
            
            json += "\","
            
            if (reminder.getRepeat() != .NO || forceDays) && !forceNoDays {
                json += "\"d\":\"" + String(reminder.getDays()) + "\","
            }
            
            json += "\"t\":\""
            for time in reminder.getTimes() {
                json += String(time) + ","
            }
            
            json += "\""
            
            
            if reminder.getNotes() != "" {
                json += ",\"n\":\"" + reminder.getNotes() + "\""
            }
            
            json += "},"
        }
        
        json += "]}"
        
        print(json)
        
        return json

    }
    
    func createWeeklyReminder(start: NSDate, end: NSDate, times: [Int16], days: Int16) -> Reminder {
        let reminder = Reminder()
        reminder.setDays(days)
        reminder.setRepeat(Repeat.YES_WEEKLY)
        reminder.setStartDate(start)
        reminder.setEndDate(end)
        reminder.setTimes(times)
        return reminder
    }
    
    func createSingleDayReminder(start: NSDate, times: [Int16]) -> Reminder {
        let reminder = Reminder()
        reminder.setDays(0)
        reminder.setRepeat(Repeat.NO)
        reminder.setStartDate(start)
        reminder.setEndDate(start)
        reminder.setTimes(times)
        return reminder
    }
    
    func createCustomReminder(start: NSDate, end: NSDate, times: [Int16], days: Int16) -> Reminder {
        let reminder = Reminder()
        reminder.setDays(days)
        reminder.setRepeat(Repeat.YES_CUSTOM)
        reminder.setStartDate(start)
        reminder.setEndDate(end)
        reminder.setTimes(times)
        return reminder
    }
}