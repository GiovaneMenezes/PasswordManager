//
//  SignInNetworkServiceType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift

/// A type that authenticate a user in a backend service
protocol SignInNetworkServiceType {

    func signInUser(with data: SignInDataType) -> Single<UserType>

}
