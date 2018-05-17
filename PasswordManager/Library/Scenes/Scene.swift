//
//  Scene.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 14/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation

enum Scene {
    case signUp(SignUpViewModel)
    case signIn(SignInViewModel)
    case biometricAuth(BiometricAuthViewModel)
//    case appLocked
//    case credentials(CredentialsViewModel)
//    case credentialDetails(EditCredentialViewModel)
}
