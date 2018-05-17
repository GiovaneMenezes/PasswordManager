//
//  MockSignUpCoordinator.swift
//  PasswordManagerTests
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
import RxSwift

@testable import PasswordManager

struct MockSignUpCoordinator: SignUpCoordinatorType {

    let signUpService: SignUpNetworkServiceType

    init(signUpService: SignUpNetworkServiceType, session: SessionType) {
        self.signUpService = signUpService
    }

    func signUpUser(with data: SignUpDataType) -> PrimitiveSequence<SingleTrait, Bool> {
        return signUpService.signUpUser(with: data)
            .map { _ in true }
    }

}
