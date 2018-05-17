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

        let passwords = viewModel.passwords

        passwords.bind(to: tableView.rx.items(
            cellIdentifier: SiteCredentialTableViewCell.reuseIdentifier,
            cellType: SiteCredentialTableViewCell.self)) { row, element, cell in
                let logoLoader = LogoNetworkService(token: UserDefaults.standard.currentToken!)
                cell.viewModel = SiteCredentialCellViewModel(sitePassword: element, imageLoader: logoLoader)
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
