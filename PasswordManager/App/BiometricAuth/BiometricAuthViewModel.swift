//
//  BiometricAuthViewModel.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 14/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import Action
import RxSwift

struct BiometricAuthViewModel {

    // MARK: Init
    private let sceneCoordinator: SceneCoordinatorType
    private let biometricAuthHandler: BiometricAuthHandlerType
    private let session: SessionType

    // MARK: Input

    // MARK: Output

    init(biometricAuthHandler: BiometricAuthHandlerType, sceneCoordinator: SceneCoordinatorType, session: SessionType = UserDefaults.standard) {
        self.biometricAuthHandler = biometricAuthHandler
        self.sceneCoordinator = sceneCoordinator
        self.session = session
    }

    lazy var onRequestAuth: CocoaAction = { biometricAuthHandler in
        return CocoaAction { biometricAuthHandler.requestBiometricAuth() }
    }(biometricAuthHandler)

    lazy var onEvaluated: CompletableAction = { this in
        return CompletableAction {
            this.session.setFirstLogin(value: false)
            let credentialsViewModel = CredentialsViewModel(sceneCoordinator: this.sceneCoordinator)
            return this.sceneCoordinator.transition(to: Scene.credentials(credentialsViewModel), type: .rootAnimated)
                .asObservable()

        }
    }(self)
}
