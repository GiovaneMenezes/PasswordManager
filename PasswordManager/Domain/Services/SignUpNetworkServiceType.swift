//
//  SignUpNetworkServiceType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 17/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
import RxSwift

/// A type that is resposible for signing up an user in a backend service
protocol SignUpNetworkServiceType {

    func signUpUser(with data: SignUpDataType) -> Single<UserType>

}
