//
//  ContainsSpecialCharPattern.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 14/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import Validator

public struct ContainsSpecialCharPattern: ValidationPattern {

    public init() {

    }

    public var pattern: String {
        return ".*[^A-Za-z0-9].*"
    }
}
