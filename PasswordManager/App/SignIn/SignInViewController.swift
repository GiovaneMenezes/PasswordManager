//
//  SignInViewController.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 15/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var goToSignUpButton: UIButton!
    var viewModel: SignInViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnViewTap()
    }
}

extension SignInViewController: BindableType {

    func bindViewModel() {

        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: rx.disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: rx.disposeBag)

        signInButton.rx.action = viewModel.signInAction
        goToSignUpButton.rx.action = viewModel.goToSignUpAction()

        viewModel.isSigningIn
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: rx.disposeBag)

        viewModel.isSignInButtonEnabled
            .drive(signInButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)

        viewModel.isTextFieldsEnabled
            .drive(emailTextField.rx.isEnabled)
            .disposed(by: rx.disposeBag)

        viewModel.isTextFieldsEnabled
            .drive(passwordTextField.rx.isEnabled)
            .disposed(by: rx.disposeBag)

        viewModel.signInAction.errors
            .subscribe(onNext: { [weak self] error in
                self?.handleError(error)
            })
            .disposed(by: rx.disposeBag)
    }

    private func handleError(_ error: ActionError) {
        if case .underlyingError(let error) = error {
            showErrorAlert(with: error)
        }
    }

}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
        return false
    }
}
