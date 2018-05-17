//
//  PasswordTableViewCell.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SiteCredentialTableViewCell: UITableViewCell {

    static let reuseIdentifier = "PasswordCell"

    @IBOutlet weak var siteLogoImageView: UIImageView!
    @IBOutlet weak var siteUrlLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var viewModel: SiteCredentialCellViewModel! {
        didSet {
            bindViewModel()
        }
    }
    var disposeBag = DisposeBag()

    func bindViewModel() {
        siteUrlLabel.text = viewModel.siteUrl
        usernameLabel.text = viewModel.username
        viewModel.logoImage
            .drive(siteLogoImageView.rx.image)
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}
