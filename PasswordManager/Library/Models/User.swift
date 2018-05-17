//
//  User.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation

struct User: UserType {

    var name: String
    var email: String
    var token: String

}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }
}
