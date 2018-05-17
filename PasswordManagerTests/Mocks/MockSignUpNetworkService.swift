//
//  MockSignUpNetworkService.swift
//  PasswordManagerTests
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
@testable import PasswordManager
import RxSwift

struct MockSignUpNetworkService: SignUpNetworkServiceType {

    func signUpUser(with data: SignUpDataType) -> Single<UserType> {
        return Single.just(User(name: "Gandalf", email: "gandalf@email.com", token: "AAAA"))
    }

}

enum MockError: Error {
    case anError
}

struct MockFailingSignUpNetworkService:  SignUpNetworkServiceType {

    func signUpUser(with data: SignUpDataType) -> Single<UserType> {
        return Single.create { observer in
            observer(.error(MockError.anError))
            return Disposables.create()
        }
    }

}
