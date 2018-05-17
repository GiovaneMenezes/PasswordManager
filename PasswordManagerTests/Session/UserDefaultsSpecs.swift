//
//  UserDefaultsSpecs.swift
//  PasswordManagerTests
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import PasswordManager

class UserDefaultsSpecs: QuickSpec {

    override func spec() {
        it("should store user in a session") {
            let session: SessionType = MockUserDefaults()
            let user = User(name: "name", email: "email", token: "token")

            session.saveUser(user)
            expect(session.currentUser).toNot(beNil())
            expect(session.isLoggedIn).to(beTrue())
            expect(user).to(equal(session.currentUser as? User))

            session.setFirstLogin(value: true)
            expect(session.isFirstLogin).to(beTrue())
            session.setFirstLogin(value: false)
            expect(session.isFirstLogin).to(beFalse())

        }

    }

}
