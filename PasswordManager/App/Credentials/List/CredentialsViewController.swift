//
//  SitePasswordTableViewController.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CredentialsViewController: UITableViewController {

    @IBOutlet weak var addCredentialBarButton: UIBarButtonItem!

    var viewModel: CredentialsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = nil
        tableView.delegate = nil
    }
}

extension CredentialsViewController: BindableType {

    func bindViewModel() {

        let credentials = viewModel.credentials

        credentials.bind(to: tableView.rx.items(
            cellIdentifier: CredentialTableViewCell.reuseIdentifier,
            cellType: CredentialTableViewCell.self)) { [weak self] row, element, cell in
                cell.siteUrlLabel.text = element.service
                cell.usernameLabel.text = element.account
                self?.viewModel.logoLoader.loadImage(from: element.service)
                    .asDriver(onErrorJustReturn: nil)
                    .drive(cell.siteLogoImageView.rx.image)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: rx.disposeBag)

        tableView.rx.itemSelected
            .do(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
            .map { [unowned self] indexPath in
                try! self.tableView.rx.model(at: indexPath)
            }
            .subscribe(viewModel.editAction.inputs)
            .disposed(by: rx.disposeBag)

        addCredentialBarButton.rx.action = viewModel.addAction
    }
}
