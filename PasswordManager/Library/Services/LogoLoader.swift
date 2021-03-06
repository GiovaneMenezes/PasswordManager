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

    let imageNetworkService: ImageNetworkServiceType

    init(imageNetworkService: ImageNetworkServiceType) {
        self.imageNetworkService = imageNetworkService
    }

    func loadImage(from url: String) -> Single<UIImage?> {
        return imageNetworkService.loadImage(from: url)
    }
}
