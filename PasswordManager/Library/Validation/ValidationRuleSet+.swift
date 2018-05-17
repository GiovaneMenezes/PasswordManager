//
//  FieldsRuleSetFactory.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 14/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import Validator

extension ValidationRuleSet {

    static var passwordRuleSet: ValidationRuleSet {
        let required = ValidationRuleEmpty(error: PasswordError.required)
        let minLengthRule = ValidationRuleLength(min: 10, lengthType: .characters, error: PasswordError.minLenth)
        let uppercaseRule = ValidationRulePattern(pattern: CaseValidationPattern.uppercase, error: PasswordError.missingUppercase)
        let numberRule = ValidationRulePattern(pattern: ContainsNumberValidationPattern(), error: PasswordError.missingNumber)
        let specialCharacterRule = ValidationRulePattern(pattern: ContainsSpecialCharPattern(), error: PasswordError.missingSpecialChar)
        var passwordRuleSet = ValidationRuleSet<String>()
        passwordRuleSet.add(rule: required)
        passwordRuleSet.add(rule: minLengthRule)
        passwordRuleSet.add(rule: uppercaseRule)
        passwordRuleSet.add(rule: numberRule)
        passwordRuleSet.add(rule: specialCharacterRule)
        return passwordRuleSet as! ValidationRuleSet<InputType>
    }

    static var emailRuleSet: ValidationRuleSet {
        let required = ValidationRuleEmpty(error: EmailError.required)
        let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: EmailError.invalid)
        var emailRuleSet = ValidationRuleSet<String>()
        emailRuleSet.add(rule: required)
        emailRuleSet.add(rule: emailRule)
        return emailRuleSet as! ValidationRuleSet<InputType>
    }

    static var nameRuleSet: ValidationRuleSet {
        let required = ValidationRuleEmpty(error: NameError.required)
        var nameRuleSet = ValidationRuleSet<String>()
        nameRuleSet.add(rule: required)
        return nameRuleSet as! ValidationRuleSet<InputType>
    }

}

struct ValidationRuleEmpty: ValidationRule {

    typealias InputType = String
    var error: Error

    func validate(input: String?) -> Bool {
        return !(input?.isEmpty ?? false)
    }
}

