//
//  UserType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation

protocol UserType: Codable {

    var name: String { get }
    var email: String { get }
    var token: String { get }

}
