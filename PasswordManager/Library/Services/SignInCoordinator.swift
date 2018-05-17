//
//  SignInCoordinator.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift

class SignInCoordinator: SignInCoordinatorType {

    let signInService: SignInNetworkServiceType
    let session: SessionType

    required init(signInService: SignInNetworkServiceType, session: SessionType = UserDefaults.standard) {
        self.signInService = signInService
        self.session = session
    }

    func signInUser(with data: SignInDataType) -> Single<Bool> {
        return signInService.signInUser(with: data)
            .storeUser(in: session)
            .map { _ in true }
    }

}
