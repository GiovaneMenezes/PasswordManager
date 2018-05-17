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

    // MARK: Input

    // MARK: Output

    init(biometricAuthHandler: BiometricAuthHandlerType, sceneCoordinator: SceneCoordinatorType) {
        self.biometricAuthHandler = biometricAuthHandler
        self.sceneCoordinator = sceneCoordinator
    }

    lazy var onRequestAuth: CocoaAction = { biometricAuthHandler in
        return CocoaAction { biometricAuthHandler.requestBiometricAuth() }
    }(biometricAuthHandler)

    lazy var onEvaluated: CompletableAction = { coordinator in
        return CompletableAction {
            return Observable<Never>.empty().asCompletable()
//            let credentialsViewModel = CredentialsViewModel(storage: CredentialsStorage(), sceneCoordinator: coordinator)
//            return coordinator.transition(to: Scene.credentials(credentialsViewModel), type: .root)
//                .asObservable()

        }
    }(sceneCoordinator)
}
