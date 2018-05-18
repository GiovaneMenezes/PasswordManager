//
//  LogoLoaderFactory.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 17/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation

struct LogoLoaderFactory {

    static func create() -> LogoLoader {
        let networkService = ImageNetworkService()
        return LogoLoader(imageNetworkService: networkService)
    }

}
