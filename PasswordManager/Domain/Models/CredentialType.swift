//
//  PasswordType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation

protocol CredentialType {
    var account: String { get }
    var server: String { get }
    func readPassword() throws -> String
    func savePassword(_ password: String) throws
    func deleteItem() throws
    mutating func update(_ newServer: String, _ newAccount: String) throws
}

func ==<T: CredentialType>(lhs: T, rhs: T) -> Bool {
    return lhs.server == rhs.server && lhs.account == rhs.account && lhs.server == rhs.server
}
