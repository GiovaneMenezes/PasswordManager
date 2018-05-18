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

class CredentialTableViewCell: UITableViewCell {

    static let reuseIdentifier = "PasswordCell"
    private(set) var disposeBag = DisposeBag()

    @IBOutlet weak var siteLogoImageView: UIImageView!
    @IBOutlet weak var siteUrlLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}
