//
//  MockUserDefaults.swift
//  PasswordManagerTests
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
@testable import PasswordManager

class MockUserDefaults: UserDefaults {

    convenience init() {
        self.init(suiteName: "Mock User Defaults")!
    }

    override init?(suiteName suitename: String?) {
        UserDefaults().removePersistentDomain(forName: suitename!)
        super.init(suiteName: suitename)
    }

}
