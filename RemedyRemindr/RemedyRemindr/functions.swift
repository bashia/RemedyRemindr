//
//  ShowAlert.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-02-15.
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
    let alpha = NSMutableCharacterSet.alphanumericCharacterSet()
    let space = NSMutableCharacterSet.whitespaceCharacterSet()
    
    alpha.formUnionWithCharacterSet(space)

    let invalidCharacters = alpha.invertedSet
    let rangeOfInvalidCharacters = textNSString.rangeOfCharacterFromSet(invalidCharacters)
    return rangeOfInvalidCharacters.location == NSNotFound
}