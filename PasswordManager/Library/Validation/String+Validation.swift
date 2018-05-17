//
//  String+Validation.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
import Validator

extension String {

    var isValidName: ValidationResult {
        return self.validate(rules: ValidationRuleSet.nameRuleSet)
    }

    var isValidEmail: ValidationResult {
        return self.validate(rules: ValidationRuleSet.emailRuleSet)
    }

    var isValidPassword: ValidationResult {
        return self.validate(rules: ValidationRuleSet.passwordRuleSet)
    }

}
