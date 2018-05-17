//
//  BiometricRequestViewController.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import UIKit
import LocalAuthentication

class BiometricAuthViewController: UIViewController, BindableType {

    @IBOutlet weak var requestBiometricAuthButton: UIButton!

    var viewModel: BiometricAuthViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {
        requestBiometricAuthButton.rx.action = viewModel.onRequestAuth
        viewModel.onRequestAuth.elements
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onEvaluated.execute(())
            })
            .disposed(by: rx.disposeBag)
    }

}
