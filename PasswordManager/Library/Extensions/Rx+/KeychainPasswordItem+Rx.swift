//
//  KeychainPasswordItem+Rx.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 17/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: CredentialType {

    func delete() -> Completable {
        return Completable.create { observer in
            do {
                try self.base.deleteItem()
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}
