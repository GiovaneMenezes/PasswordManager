//
//  seed.swift
//  PasswordManagerTests
//
//  Created by Caio Sanchez Santos Costa on 18/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
@testable import PasswordManager

struct Seed {

    static let credentials = [KeychainPasswordItem(server: "www.wizards.com",
                                            account: "theGray",
                                            creator: user.email),
                       KeychainPasswordItem(server: "www.lordOfTheRings.com",
                                            account: "wizard",
                                            creator: user.email)
                       ]

    static let user = User(name: "Gandalf", email: "gandalf@wizard.com", token: "ABCD-1234")

}
