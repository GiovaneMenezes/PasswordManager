//
//  PasswordDetailsTableViewController.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditCredentialViewController: UITableViewController {

    @IBOutlet weak var siteUrlTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteCell: UITableViewCell!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var togglePasswordVisibiltyButton: UIButton!

    var viewModel: EditCredentialViewModel!

}

extension EditCredentialViewController: BindableType {

    func bindViewModel() {

        viewModel.siteUrlInput.asDriver(onErrorJustReturn: "")
            .drive(siteUrlTextField.rx.text)
            .disposed(by: rx.disposeBag)

        viewModel.usernameInput.asDriver(onErrorJustReturn: "")
            .drive(usernameTextField.rx.text)
            .disposed(by: rx.disposeBag)

        viewModel.passwordInput.asDriver(onErrorJustReturn: "")
            .drive(passwordTextField.rx.text)
            .disposed(by: rx.disposeBag)

        siteUrlTextField.rx.text.orEmpty
            .bind(to: viewModel.siteUrlInput)
            .disposed(by: rx.disposeBag)

        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.usernameInput)
            .disposed(by: rx.disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordInput)
            .disposed(by: rx.disposeBag)

        cancelBarButton.rx.action = viewModel.onCancel()
        deleteButton.rx.action = viewModel.deleteAction


        let inputs = Observable.combineLatest(
            siteUrlTextField.rx.text.orEmpty.asObservable(),
            usernameTextField.rx.text.orEmpty.asObservable(),
            passwordTextField.rx.text.orEmpty.asObservable()
        )

        saveBarButton.rx.tap
            .withLatestFrom(inputs)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)

        viewModel.shouldShowDeleteButton
            .map { !$0 }
            .drive(deleteCell.rx.isHidden)
            .disposed(by: rx.disposeBag)

        viewModel.isSaveButtonEnabled
            .drive(saveBarButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)

        togglePasswordVisibiltyButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
                let title = self.passwordTextField.isSecureTextEntry ? "show" : "hide"
                self.togglePasswordVisibiltyButton.setTitle(title, for: .normal)
            })
            .disposed(by: rx.disposeBag)

        copyButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                UIPasteboard.general.string = self.passwordTextField.text
            })
            .disposed(by: rx.disposeBag)

        viewModel.shouldShowCopyButton
            .map { !$0 }
            .drive(copyButton.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }
}
