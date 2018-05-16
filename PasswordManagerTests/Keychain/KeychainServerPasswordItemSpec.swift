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

            var passwordItem = KeychainServerPasswordItem(server: "www.wizards.org", account: "theGray", creator: "gandalf@wizard.com")
            let password = "sauronIsDead"

            afterEach {
                try! KeychainServerPasswordItem.deleteAll()
            }

            it("should save item") {

                var savedItem: KeychainServerPasswordItem?
                var savedPassword: String?
                do {
                    try passwordItem.savePassword(password)
                    savedItem = try KeychainServerPasswordItem
                        .passwordItems(forCreator: passwordItem.creator, server: passwordItem.server).first
                    savedPassword = try savedItem!.readPassword()
                } catch {
                    fail("Failed with error: \(error)")
                }
                expect(passwordItem).to(equal(savedItem))
                expect(password).to(equal(savedPassword))
            }

            it("should rename account") {

                let newAccountName = "theWhite"
                try! passwordItem.savePassword(password)
                var savedItem: KeychainServerPasswordItem?
                do {
                    try passwordItem.renameAccount(newAccountName)
                    savedItem = try KeychainServerPasswordItem
                        .passwordItems(forCreator: passwordItem.creator, server: passwordItem.server).first
                } catch {
                    fail("Failed with error: \(error)")
                }
                expect(savedItem?.account).to(equal(newAccountName))
            }

            it("should delete saved item") {
                try! passwordItem.savePassword("12345")
                var item: KeychainServerPasswordItem?
                do {
                    try passwordItem.deleteItem()
                    item = try KeychainServerPasswordItem
                        .passwordItems(forCreator: passwordItem.creator, server: passwordItem.server).first
                } catch {
                    fail("Failed with error: \(error)")
                }
                expect(item).to(beNil())

            }

        }
    }

}
