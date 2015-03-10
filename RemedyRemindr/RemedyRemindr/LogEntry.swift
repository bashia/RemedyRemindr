//
//  LogEntry.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-03-10.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import Foundation

class LogEntry: NSObject {
    private var date: NSDate
    private var text: String
    
    init(date:NSDate, text:String){
        self.date = date
        self.text = text
    }

    func getDate() -> NSDate{
        return date
    }
    
    func getDateAsString() -> String{
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return formatter.stringFromDate(date)
    }
    
    func getText() -> String{
        return text
    }
    
    func setDate(date:NSDate){
        self.date = date
    }
    
    func setText(text:String){
        self.text = text
    }



}