//
//  AppLockedViewModel.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 18/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct AppLockedViewModel {

    // MARK: Init
    private let sceneCoordinator: SceneCoordinator
    private let biometricAuthHandler: BiometricAuthHandlerType
    private let session: SessionType
    // MARK: Input

    // MARK: Output

    init(session: SessionType = UserDefaults.standard, biometricAuthHandler: BiometricAuthHandlerType, sceneCoordinator: SceneCoordinator) {
        self.session = session
        self.sceneCoordinator = sceneCoordinator
        self.biometricAuthHandler = biometricAuthHandler
    }

    func unlockAppAction() -> CocoaAction {
        return CocoaAction {
            return self.biometricAuthHandler.requestBiometricAuth()
                .flatMap { _ -> Completable in
                    self.session.setAppLocked(value: false)
                    return self.sceneCoordinator.pop()
                }
                .map { _ in }
        }
    }

}
