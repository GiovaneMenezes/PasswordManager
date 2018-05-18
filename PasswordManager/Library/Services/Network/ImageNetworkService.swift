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

struct ImageNetworkService: ImageNetworkServiceType {

    let provider: MoyaProvider<CedroAPI>
    let session: SessionType

    init(provider: MoyaProvider<CedroAPI> = MoyaProvider<CedroAPI>(), session: SessionType = UserDefaults.standard) {
        self.provider = provider
        self.session = session
    }

    func loadImage(from url: String) -> Single<UIImage?> {
        return provider.rx.request(.logo(url: url, token: session.apiToken!))
            .mapImage()
    }
}
