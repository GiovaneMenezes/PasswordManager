//
//  SignUpViewModelSpec.swift
//  PasswordManagerTests
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
import RxCocoa
import RxNimble
import Action
import UIKit
@testable import PasswordManager

class SignUpViewModelSpec: QuickSpec {

    func createViewModel(networkService: SignUpNetworkServiceType) -> SignUpViewModel {
        let session = MockUserDefaults()
        let signUpCoordinator = MockSignUpCoordinator(signUpService: networkService, session: session)
        let sceneCoordinator = MockSceneCoordinator()
        return SignUpViewModel(signUpCoordinator: signUpCoordinator, sceneCoordinator: sceneCoordinator)
    }

    override func spec() {

        var disposeBag: DisposeBag!
        var testScheduler: TestScheduler!
        var viewModel: SignUpViewModel!
        var nameInput: PublishSubject<String>!
        var emailInput: PublishSubject<String>!
        var passwordInput: PublishSubject<String>!
        let signUpNetworkService = MockSignUpNetworkService()

        beforeEach {
            disposeBag = DisposeBag()
            testScheduler = TestScheduler(initialClock: 0)
            viewModel = self.createViewModel(networkService: signUpNetworkService)

            nameInput = PublishSubject<String>()
            emailInput = PublishSubject<String>()
            passwordInput = PublishSubject<String>()

            nameInput.bind(to: viewModel.name).disposed(by: disposeBag)
            emailInput.bind(to: viewModel.email).disposed(by: disposeBag)
            passwordInput.bind(to: viewModel.password).disposed(by: disposeBag)
        }


        describe("SignUpViewModel") {

            it("should enable signUpButton when fields valid") {

                let observer = testScheduler.createObserver(Bool.self)
                viewModel.isSignUpButtonEnabled.asObservable().subscribe(observer).disposed(by: disposeBag)
                testScheduler.start()
                // First: Invalid inputs
                nameInput.onNext("Gandalf")
                emailInput.onNext("gandalf@email")
                passwordInput.onNext("Senha12345")

                // Second: Valid inputs
                emailInput.onNext("gandalf@email.com")
                passwordInput.onNext("Senha@123456")
                nameInput.onNext("")

                let results = observer.events.map { $0.value.element! }

                // initialValue + 4 inputs before password got valid + erase name and got false
                expect(results).to(equal([false, false, false, false, false, true, false]))
            }

            describe("user press sign up button") {

                beforeEach {
                    nameInput.onNext("Gandalf")
                    emailInput.onNext("gandalf@email")
                    passwordInput.onNext("Senha@123456")
                }

                it("should show loading") {
                    viewModel.signUpAction.execute(())
                    expect(viewModel.isSigningUp.asObservable()).first == true
                }

                it("should disable fields") {
                    viewModel.signUpAction.execute(())
                    expect(viewModel.isTextFieldsEnabled.asObservable()).first == false
                }

                it("should disable signUpButton") {
                    viewModel.signUpAction.execute(())
                    expect(viewModel.isSignUpButtonEnabled.asObservable()).first == false
                }
            }
        }
    }
}
