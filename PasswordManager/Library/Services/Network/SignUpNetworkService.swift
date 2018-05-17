//
//  SignUpNetworkService.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 14/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct SignUpNetworkService: SignUpNetworkServiceType {

    private let provider: MoyaProvider<CedroAPI>

    init(provider: MoyaProvider<CedroAPI> = MoyaProvider<CedroAPI>()) {
        self.provider = provider
    }

    func signUpUser(with data: SignUpDataType) -> Single<UserType> {
        return provider.rx.request(.signUp(data))
            .map(APIResponse.self)
            .map { response in
                guard response.successful, let token = response.token else {
                    let message = response.message ?? "An error ocurred"
                    throw APIError.error(message: message, errors: response.errors)
                }
                return User(name: data.name, email: data.email, token: token)
            }
    }

}



