//
//  PasswordType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation

protocol CredentialType: Storable {
    var account: String { get }
    var server: String { get }
    func readPassword() throws -> String
    func savePassword(_ password: String) throws
    func deleteItem() throws
    mutating func update(_ newServer: String, _ newAccount: String) throws
}