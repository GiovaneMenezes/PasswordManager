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

class EditCredentialViewController: UITableViewController, BindableType {

    @IBOutlet weak var siteUrlTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteCell: UITableViewCell!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    var viewModel: EditCredentialViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    func bindViewModel() {

        siteUrlTextField.text = viewModel.siteUrl
        usernameTextField.text = viewModel.username
        passwordTextField.text = viewModel.password

        siteUrlTextField.rx.text.orEmpty
            .bind(to: viewModel.siteUrlInput)
            .disposed(by: rx.disposeBag)

        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.usernameInput)
            .disposed(by: rx.disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordInput)
            .disposed(by: rx.disposeBag)

        let inputs = Observable.combineLatest(
            siteUrlTextField.rx.text.orEmpty.asObservable(),
            usernameTextField.rx.text.orEmpty.asObservable(),
            passwordTextField.rx.text.orEmpty.asObservable()
        )

        cancelBarButton.rx.action = viewModel.onCancel()

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

        tableView.rx.itemSelected
            .filter { $0.section == 1 }
            .withLatestFrom(viewModel.credential)
            .bind(to: viewModel.deleteAction!.inputs)
            .disposed(by: rx.disposeBag)
    }

}
