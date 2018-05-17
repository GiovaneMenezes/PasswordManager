//
//  ValidationError.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 14/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation

enum PasswordError: Error {
    case required
    case minLenth
    case missingUppercase
    case missingNumber
    case missingSpecialChar

    enum ErrorMessages: String {
        case required = "The password is required"
        case minLength = "The password must be at least 10 characters long."
        case missingUppercase = "The password must contain at least one uppercase letter."
        case missiginNumber = "The password must contain at least one number."
        case missingSpecialChar = "The password must contain at least one special character."
    }
}

extension PasswordError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .minLenth:
            return ErrorMessages.minLength.rawValue
        case .missingUppercase:
            return ErrorMessages.missingUppercase.rawValue
        case .missingNumber:
            return ErrorMessages.missiginNumber.rawValue
        case .missingSpecialChar:
            return ErrorMessages.missingSpecialChar.rawValue
        case .required:
            return ErrorMessages.required.rawValue
        }
    }
}

enum EmailError: Error {
    case required
    case invalid

    enum ErrorMessage: String {
        case required = "The email is required"
        case invalid = "The email is invalid"
    }
}

extension EmailError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .required:
            return ErrorMessage.required.rawValue
        case .invalid:
            return ErrorMessage.invalid.rawValue
        }
    }
}

enum NameError: Error {
    case required

    enum ErrorMessage: String {
        case required = "The name is required"
    }
}

extension NameError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .required:
            return ErrorMessage.required.rawValue
        }
    }
}

