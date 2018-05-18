//
//  KeychainServerPasswordItemSpec.swift
//  PasswordManagerTests
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Quick
import Nimble
@testable import PasswordManager

class KeychainServerPasswordItemSpec: QuickSpec {

    override func spec() {

        describe("KeychainServerPasswordItem") {

            var passwordItem = KeychainPasswordItem(server: "www.wizards.org", account: "theGray", creator: "gandalf@wizard.com")
            let password = "sauronIsDead"

            afterEach {
                try! KeychainPasswordItem.deleteAll()
            }

            it("should save item") {

                var savedItem: KeychainPasswordItem?
                var savedPassword: String?
                do {
                    try passwordItem.savePassword(password)
                    savedItem = try KeychainPasswordItem
                        .passwordItems(forCreator: passwordItem.creator, server: passwordItem.server).first
                    savedPassword = try savedItem!.readPassword()
                } catch {
                    fail("Failed with error: \(error)")
                }
                expect(passwordItem).to(equal(savedItem))
                expect(password).to(equal(savedPassword))
            }

            it("should rename server and account") {

                let newAccountName = "theWhite"
                let newSeverName = "www.gondor.com"
                try! passwordItem.savePassword(password)
                var savedItem: KeychainPasswordItem?
                do {
                    try passwordItem.update(newSeverName, newAccountName)
                    savedItem = try KeychainPasswordItem
                        .passwordItems(forCreator: passwordItem.creator, server: passwordItem.server).first
                } catch {
                    fail("Failed with error: \(error)")
                }
                expect(savedItem).to(equal(passwordItem))
            }

            it("should delete saved item") {
                try! passwordItem.savePassword("12345")
                var item: KeychainPasswordItem?
                do {
                    try passwordItem.deleteItem()
                    item = try KeychainPasswordItem
                        .passwordItems(forCreator: passwordItem.creator, server: passwordItem.server).first
                } catch {
                    fail("Failed with error: \(error)")
                }
                expect(item).to(beNil())

            }

        }
    }

}
