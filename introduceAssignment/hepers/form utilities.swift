//
//  form utilities.swift
//  hostelSearch
//
//  Created by madhur bansal on 11/2/19.
//  Copyright © 2019 madhur bansal. All rights reserved.
//

import Foundation

class FormUtilities
{
    static func isEmailValid(_ email:String)->Bool
    {
        let emailText = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailText.evaluate(with: email)
    }
    
    static func isPasswordValid(_ password:String)->Bool
    {
        let passwordText = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordText.evaluate(with: password)
    }
    static func isPhoneNumberValid(_ phoneNumber:String)->Bool
    {
        let phoneNumberText = NSPredicate(format: "SELF MATCHES %@", "^\\d{3}\\d{3}\\d{4}$")
        return phoneNumberText.evaluate(with: phoneNumber)
    }
    
    static func isGSTNumberValid(_ GSTNumber:String)->Bool
    {
        let gstText = NSPredicate(format: "SELF MATCHES %@", "^[0-9]{2}[A-Z]{5}[0-9]{4}" + "[A-Z]{1}[1-9A-Z]{1}" + "Z[0-9A-Z]{1}$")
        return gstText.evaluate(with: GSTNumber)
    }
}
