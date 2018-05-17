//
//  SignUpCoordinator.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift

class SignUpCoordinator: SignUpCoordinatorType {

    let signUpService: SignUpNetworkServiceType
    let session: SessionType

    required init(signUpService: SignUpNetworkServiceType, session: SessionType = UserDefaults.standard) {
        self.signUpService = signUpService
        self.session = session
    }

    func signUpUser(with data: SignUpDataType) -> Single<Bool> {
        return signUpService.signUpUser(with: data)
            .debug("Sign up user")
            .storeUser(in: session)
            .map { _ in true }
    }

}
