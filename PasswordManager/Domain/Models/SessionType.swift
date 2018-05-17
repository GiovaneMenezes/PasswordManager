//
//  SessionType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation

/// A type that managers the data related to a logged in session
protocol SessionType {

    var apiToken: String? { get }
    var currentUser: UserType? { get }
    var isLoggedIn: Bool { get }
    var isFirstLogin: Bool { get }
    func saveUser(_ user: UserType)
    func removeCurrentUser()
    func setFirstLogin(value: Bool)
}

extension SessionType {

    var isLoggedIn: Bool {
        return currentUser != nil
    }

}
