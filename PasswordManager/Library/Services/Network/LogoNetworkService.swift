//
//  LogoNetworkService.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 15/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct LogoNetworkService: ImageLoaderType {

    let provider: MoyaProvider<CedroAPI>
    let token: String

    init(provider: MoyaProvider<CedroAPI> = MoyaProvider<CedroAPI>(), token: String) {
        self.token = token
        self.provider = provider
    }

    func loadImage(from url: String) -> Single<UIImage?> {
        return provider.rx.request(.logo(url: url, token: token))
            .debug()
            .mapImage()
    }
}
