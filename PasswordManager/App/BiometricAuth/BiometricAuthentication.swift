//
//  BiometricAuthentication.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 14/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import LocalAuthentication
import RxSwift

enum BiometricAuthError: Error {
    case error(message: String)
}

extension BiometricAuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .error(let message):
            return message
        }
    }
}

struct BiometricIDAuth: BiometricAuthHandlerType {

    private let context = LAContext()
    private let localizedReason = "Test"

    func canEvaluatePolicy() -> Bool {
        let result = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return result
    }

    func requestBiometricAuth() -> Observable<Void> {
        return Observable.create { observer in

            guard self.canEvaluatePolicy() else {
                observer.onError((BiometricAuthError.error(message: "Touch ID not supported")))
                return Disposables.create()
            }

            self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.localizedReason) { (success, evaluateError) in
                if success {
                    DispatchQueue.main.async {
                        print("Evaludated")
                        observer.onNext(())
                        observer.onCompleted()
                    }
                } else {
                    let message: String

                    switch evaluateError {
                    case LAError.authenticationFailed?:
                        message = "There was a problem verifying your identity."
                    case LAError.userCancel?:
                        message = "You pressed cancel."
                    case LAError.userFallback?:
                        message = "You pressed password."
                    case LAError.biometryNotAvailable?:
                        message = "Face ID/Touch ID is not available."
                    case LAError.biometryNotEnrolled?:
                        message = "Face ID/Touch ID is not set up."
                    case LAError.biometryLockout?:
                        message = "Face ID/Touch ID is locked."
                    default:
                        message = "Face ID/Touch ID may not be configured"
                    }
                    observer.onError(BiometricAuthError.error(message: message))                           }
            }
            return Disposables.create()
        }
    }

}
