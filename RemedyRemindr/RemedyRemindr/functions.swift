//
//  ShowAlert.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-15.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import Foundation
import UIKit
    
func newAlert(title: String, message: String) {
    var alert : UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
    alert.show()
}

func checkValidCharacters(text: String) -> Bool {
    let textNSString = text as NSString
    let invalidCharacters = NSCharacterSet.alphanumericCharacterSet().invertedSet
    let rangeOfInvalidCharacters = textNSString.rangeOfCharacterFromSet(invalidCharacters)
    return rangeOfInvalidCharacters.location == NSNotFound
}