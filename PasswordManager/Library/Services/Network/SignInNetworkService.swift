//
//  SignInNetworkService.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 15/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct SignInNetworkService: SignInNetworkServiceType {

    private let provider: MoyaProvider<CedroAPI>

    init(provider: MoyaProvider<CedroAPI> = MoyaProvider<CedroAPI>()) {
        self.provider = provider
    }

    func signInUser(with data: SignInDataType) -> Single<UserType> {
        return provider.rx.request(.signIn(data))
            .map(APIResponse.self)
            .map { response in
                guard response.successful, let token = response.token else {
                    let message = response.message ?? "An error ocurred"
                    throw APIError.error(message: message, errors: response.errors)
                }
                return User(name: "Unkown", email: data.email, token: token)
        }
    }

}
