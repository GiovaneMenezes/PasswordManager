//
//  UserDefaults+SessionType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation

extension UserDefaults: SessionType {

    var apiToken: String? {
        return currentUser?.token
    }

    private enum Keys: String {
        case user
    }

    var currentUser: UserType? {
        return fetch(forKey: Keys.user.rawValue, type: User.self)
    }

    var currentToken: String? {
        return currentUser?.token
    }

    func saveUser(_ user: UserType) {
        store(user as! User, forKey: Keys.user.rawValue)
    }

    func removeCurrentUser() {
        removeObject(forKey: Keys.user.rawValue)
    }

    var isFirstLogin: Bool {
        guard let email = currentUser?.email else { return true }
        return !bool(forKey: email)
    }

    func setFirstLogin(value: Bool) {
        guard let email = currentUser?.email else { return }
        if value {
            removeObject(forKey: email)
        } else {
            set(true, forKey: email)
        }
    }
    

}
