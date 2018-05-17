//
//  SignUpData.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation

struct SignUpData: SignUpDataType {

    let name: String
    let email: String
    let password: String
    var isValid: Bool {
        return !name.isEmpty && !email.isEmpty && !password.isEmpty
    }

}
