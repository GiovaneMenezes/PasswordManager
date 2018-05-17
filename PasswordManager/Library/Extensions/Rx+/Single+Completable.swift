//
//  Single+Completable.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift

extension PrimitiveSequence where TraitType == SingleTrait {

    public func asCompletable() -> PrimitiveSequence<CompletableTrait, Never> {
        return self.asObservable().flatMap { _ in Observable<Never>.empty() }.asCompletable()
    }
    
}
