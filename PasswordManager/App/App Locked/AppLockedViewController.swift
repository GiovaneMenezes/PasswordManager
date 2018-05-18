//
//  AppLockedViewController.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 18/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import UIKit

class AppLockedViewController: UIViewController {

    @IBOutlet weak var biometricAuthButton: UIButton!
    var viewModel: AppLockedViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension AppLockedViewController: BindableType {

    func bindViewModel() {
        biometricAuthButton.rx.action = viewModel.unlockAppAction()
    }
}
