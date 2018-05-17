//
//  SignInManagerType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift

/// A type that coordinates the sevices related to sign in an user
protocol SignInCoordinatorType {

    func signInUser(with data: SignInDataType) -> Single<Bool>

    init(signInService: SignInNetworkServiceType, session: SessionType)

}
