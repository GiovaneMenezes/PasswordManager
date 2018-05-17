//
//  PasswordCellViewModel.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import Action
import RxCocoa

struct SiteCredentialCellViewModel {

    // MARK: Init
    private let imageLoader: ImageLoaderType

    // MARK: Output
    let siteUrl: String
    let username: String
    let logoImage: Driver<UIImage?>

    init(sitePassword: CredentialType, imageLoader: ImageLoaderType) {
        self.imageLoader = imageLoader
        siteUrl = sitePassword.server
        username = sitePassword.account
        logoImage = imageLoader.loadImage(from: siteUrl).debug().asDriver(onErrorJustReturn: nil)
    }

}
