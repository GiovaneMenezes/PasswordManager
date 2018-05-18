//
//  LogoLoader.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 17/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
import RxSwift

struct LogoLoader: ImageLoaderType {

    let signInService: ImageNetworkServiceType

    init(signInService: ImageNetworkServiceType) {
        self.signInService = signInService
    }

    func loadImage(from url: String) -> Single<UIImage?> {
        return signInService.loadImage(from: url)
    }
}
