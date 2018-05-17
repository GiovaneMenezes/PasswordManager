//
//  SignUpViewModel.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import Action
import RxSwift
import RxCocoa
import Validator

struct SignUpViewModel {

    // MARK: Dependencies
    private let signUpCoordinator: SignUpCoordinatorType
    private let sceneCoordinator: SceneCoordinatorType

    // MARK: Input
    let name = BehaviorSubject<String>(value: "")
    let email = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")

    // MARK: Output
    var isSigningUp: Driver<Bool>!
    var isTextFieldsEnabled: Driver<Bool>!
    var isSignUpButtonEnabled: Driver<Bool>!

    var shouldShowNameErrorLabel: Driver<Bool>!
    var shouldShowEmailErrorLabel: Driver<Bool>!
    var shouldShowPasswordErrorLabel: Driver<Bool>!

    var nameErrorMessage: Driver<String>
    var emailErrorMessage: Driver<String>
    var passwordErrorMessage: Driver<String>

    // MARK: Private Properties
    private var signUpData: Observable<SignUpData>

    init(signUpCoordinator: SignUpCoordinatorType, sceneCoordinator: SceneCoordinatorType) {
        self.signUpCoordinator = signUpCoordinator
        self.sceneCoordinator = sceneCoordinator

        signUpData = Observable
            .combineLatest(name, email, password)
            .map { SignUpData(name: $0, email: $1, password: $2) }

        let nameValidationResult = name.map { $0.isValidName }
        let emailValidationResult = email.map { $0.isValidEmail }
        let passwordValidationResult = password.map { $0.isValidPassword }

        shouldShowNameErrorLabel = nameValidationResult
            .map { !$0.isValid }
            .skip(2) // Skips initial state and textField first responser to only show when user starts typing
            .startWith(false)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)

        shouldShowEmailErrorLabel = emailValidationResult
            .map { !$0.isValid }
            .skip(2)
            .startWith(false)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)

        shouldShowPasswordErrorLabel = passwordValidationResult
            .map { !$0.isValid }
            .skip(2)
            .startWith(false)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)

        nameErrorMessage =  nameValidationResult
            .map { $0.firstErrorDescription ?? "" }
            .asDriver(onErrorJustReturn: "")

        emailErrorMessage = emailValidationResult
            .map { $0.firstErrorDescription ?? "" }
            .asDriver(onErrorJustReturn: "")

        passwordErrorMessage = passwordValidationResult
            .map { $0.firstErrorDescription ?? "" }
            .asDriver(onErrorJustReturn: "")

        isSigningUp = signUpAction.executing.debug("isSigninUp").asDriver(onErrorJustReturn: false)
        isTextFieldsEnabled = isSigningUp.map { !$0 }

        isSignUpButtonEnabled = Observable
            .combineLatest(nameValidationResult, emailValidationResult, passwordValidationResult, isSigningUp.asObservable())
            .map { $0.isValid && $1.isValid && $2.isValid && !$3 }
            .asDriver(onErrorJustReturn: false)
    }

    func goToSignInAction() -> CocoaAction {
        return CocoaAction { _ in
            let signInCoordinator = SignInCoordinator(signInService: SignInNetworkService())
            let viewModel = SignInViewModel(signInCoordinator: signInCoordinator, sceneCoordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.signIn(viewModel), type: .rootAnimated)
                .asObservable()
                .map { _ in }
        }
    }

    lazy var signUpAction: CocoaAction = { this in
        return CocoaAction { _ in
            return this.signUpData
                .flatMapLatest {
                    this.signUpCoordinator.signUpUser(with: $0) }
                .flatMap { _ -> Completable in
                    let viewModel = BiometricAuthViewModel(biometricAuthHandler: BiometricIDAuth(), sceneCoordinator: this.sceneCoordinator)
                    return this.sceneCoordinator.transition(to: Scene.biometricAuth(viewModel), type: .rootAnimated)
                }
                .asObservable()
                .map { _ in }
        }
    }(self)

}

extension ValidationResult {

    var firstErrorDescription: String? {
        if case .invalid(let error) = self {
            return error.first?.localizedDescription
        }
        return nil
    }

}
