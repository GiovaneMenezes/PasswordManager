//
//  SignUpViewController.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import UIKit
import RxCocoa
import Action
import RxAnimated

class SignUpViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var goToSignInButton: UIButton!

    // MARK: - Properties
    var viewModel: SignUpViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnViewTap()
    }

}

extension SignUpViewController: BindableType {

    func bindViewModel() {
        // Inputs
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.name)
            .disposed(by: rx.disposeBag)
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: rx.disposeBag)
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: rx.disposeBag)

        // Outputs
        signUpButton.rx.action = viewModel.signUpAction
        goToSignInButton.rx.action = viewModel.goToSignInAction()

        viewModel.signUpAction.errors
            .subscribe(onNext: { [weak self] error in
                self?.handleError(error)
            })
            .disposed(by: rx.disposeBag)
        viewModel.isTextFieldsEnabled.drive(nameTextField.rx.isEnabled).disposed(by: rx.disposeBag)
        viewModel.isTextFieldsEnabled.drive(emailTextField.rx.isEnabled).disposed(by: rx.disposeBag)
        viewModel.isTextFieldsEnabled.drive(passwordTextField.rx.isEnabled).disposed(by: rx.disposeBag)
        viewModel.isSigningUp.drive(activityIndicator.rx.isAnimating).disposed(by: rx.disposeBag)
        viewModel.isSignUpButtonEnabled.drive(signUpButton.rx.isEnabled).disposed(by: rx.disposeBag)

        viewModel.shouldShowNameErrorLabel
            .map { $0 ? 1 : 0 }
            .drive(nameErrorLabel.rx.animated.fade(duration: 0.3).alpha)
            .disposed(by: rx.disposeBag)

        viewModel.shouldShowEmailErrorLabel
            .map { $0 ? 1 : 0 }
            .drive(emailErrorLabel.rx.animated.fade(duration: 0.3).alpha)
            .disposed(by: rx.disposeBag)

        viewModel.shouldShowPasswordErrorLabel
            .map { $0 ? 1 : 0 }
            .bind(animated: passwordErrorLabel.rx.animated.fade(duration: 0.3).alpha)
            .disposed(by: rx.disposeBag)

        viewModel.nameErrorMessage
            .bind(animated: nameErrorLabel.rx.animated.fade(duration: 0.3).text)
            .disposed(by: rx.disposeBag)

        viewModel.emailErrorMessage
            .bind(animated: emailErrorLabel.rx.animated.fade(duration: 0.3).text)
            .disposed(by: rx.disposeBag)

        viewModel.passwordErrorMessage
            .bind(animated: passwordErrorLabel.rx.animated.fade(duration: 0.3).text)
            .disposed(by: rx.disposeBag)
    }

    func handleError(_ error: ActionError) {
        if case .underlyingError(let error) = error {
            showErrorAlert(with: error)
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
        return false
    }
}
