//
//  ObservableType+UserType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift

extension PrimitiveSequenceType where TraitType == SingleTrait, ElementType == UserType {

    func storeUser(in session: SessionType) -> Single<ElementType> {
        return self.do(onSuccess: { user in
            session.saveUser(user)
        })
    }

}
