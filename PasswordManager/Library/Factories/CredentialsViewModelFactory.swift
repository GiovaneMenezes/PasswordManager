//
//  CredentialsViewModelFactory.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 17/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation

struct CredentialsViewModelFactory {

    static func create(sceneCoordinator: SceneCoordinatorType) -> CredentialsViewModel {
        let credentialsViewModel = CredentialsViewModel(sceneCoordinator: sceneCoordinator, logoLoader: LogoLoaderFactory.create())
        return credentialsViewModel
    }

}
