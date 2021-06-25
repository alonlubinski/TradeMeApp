//
//  Validation.swift
//  TradeMe
//
//  Created by user196684 on 6/11/21.
//

import Foundation
import UIKit

class Validation {
    
    static func emailIsValid(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func passwordsMatch(_ password1:String, _ password2:String) -> Bool{
        return password1 == password2
    }
    
    static func fieldIsNotEmpty(_ field:UITextField) -> Bool {
        return field.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""
    }
    
}
