//
//  SignInViewModel.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 14/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Action

struct SignInViewModel {

    // MARK: Dependencies
    private let signInCoordinator: SignInCoordinatorType
    private let sceneCoordinator: SceneCoordinatorType
    private let session: SessionType

    // MARK: Input
    let email = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")

    // MARK: Output
    var isSigningIn: Driver<Bool>!
    var isTextFieldsEnabled: Driver<Bool>!
    var isSignInButtonEnabled: Driver<Bool>!

    // MARK: Private Properties
    private var signInData: Observable<SignInDataType>

    init(signInCoordinator: SignInCoordinatorType,
         sceneCoordinator: SceneCoordinatorType,
         session: SessionType = UserDefaults.standard) {

        self.signInCoordinator = signInCoordinator
        self.sceneCoordinator = sceneCoordinator
        self.session = session

        signInData = Observable.combineLatest(email, password) { SignInData(email: $0, password: $1) }

        isSigningIn = signInAction.executing.asDriver(onErrorJustReturn: false)
        isTextFieldsEnabled = isSigningIn.map { !$0 }
        isSignInButtonEnabled = Observable
            .combineLatest(email, password, isSigningIn.asObservable()) {
                !$0.isEmpty && !$1.isEmpty && !$2
            }
            .asDriver(onErrorJustReturn: false)
    }

    func goToSignUpAction() -> CocoaAction {
        return CocoaAction { _ in
            let signUpCoordinator = SignUpCoordinator(signUpService: SignUpNetworkService())
            let viewModel = SignUpViewModel(signUpCoordinator: signUpCoordinator, sceneCoordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.signUp(viewModel), type: .rootAnimated)
                .asObservable()
                .map { _ in }
        }
    }

    lazy var signInAction: CocoaAction = { this in
        return CocoaAction { _ in
            return this.signInData
                .flatMapLatest {  this.signInCoordinator.signInUser(with: $0) }
                .flatMap { _ -> Completable in
                    if this.session.isFirstLogin  {
                        let viewModel = BiometricAuthViewModel(biometricAuthHandler: BiometricIDAuth(), sceneCoordinator: this.sceneCoordinator)
                        return this.sceneCoordinator
                            .transition(to: .biometricAuth(viewModel), type: .rootAnimated)
                    }

                    let viewModel = CredentialsViewModel(sceneCoordinator: this.sceneCoordinator)
                    
                    return this.sceneCoordinator
                        .transition(to: .credentials(viewModel), type: .rootAnimated)
                }
                .map { _ in }
        }
    }(self)

}
