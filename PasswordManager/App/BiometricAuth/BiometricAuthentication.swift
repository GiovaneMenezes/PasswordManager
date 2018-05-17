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
    private let localizedReason = "To access the secure data"

    func requestBiometricAuth() -> Observable<Void> {
        return Observable.create { observer in

            var authError: NSError?
            if self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.localizedReason) { success, evaluateError in
                    if success {
                        // User authenticated successfully, take appropriate action
                        DispatchQueue.main.async {
                            observer.onNext(())
                            observer.onCompleted()
                        }
                    } else {
                        guard let error = evaluateError as NSError? else {
                            observer.onError(BiometricAuthError.error(message: "An unkown error ocurred"))
                            return
                        }
                        let message = self.evaluatePolicyFailErrorMessageForLA(errorCode: error.code)
                        observer.onError(BiometricAuthError.error(message: message))
                    }
                }
            } else {
                guard let error = authError else {
                    observer.onError(BiometricAuthError.error(message: "An unkown error ocurred"))
                    return Disposables.create()
                }
                let message = self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code)
                observer.onError(BiometricAuthError.error(message: message))
            }
            return Disposables.create()
        }
    }

    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {

        var message = ""

        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"

        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"

        case LAError.invalidContext.rawValue:
            message = "The context is invalid"

        case LAError.notInteractive.rawValue:
            message = "Not interactive"

        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"

        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"

        case LAError.userCancel.rawValue:
            message = "The user did cancel"

        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        return message
    }

    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        switch errorCode {
        case LAError.biometryNotAvailable.rawValue:
            message = "Authentication could not start because the device does not support biometric authentication."

        case LAError.biometryLockout.rawValue:
            message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."

        case LAError.biometryNotEnrolled.rawValue:
            message = "Authentication could not start because the user has not enrolled in biometric authentication."
        default:
            message = "Did not find error code on LAError object"
        }
        return message;
    }
}
