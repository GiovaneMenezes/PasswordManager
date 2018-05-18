//
//  SignUpCoordinatorType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
import RxSwift

/// A type that coordinates the sevices related to sign up a new user
protocol SignUpCoordinatorType {

    func signUpUser(with data: SignUpDataType) -> Single<Bool>

    init(signUpService: SignUpNetworkServiceType, session: SessionType)

}
