//
//  Database.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift

protocol Storable { }

protocol ReadableStorage {
    func fetchAll<T: Storable>(storableType: T.Type) -> Observable<[T]>
}

protocol WriteableStorage {
    func save<T: Storable>(_ object: T) -> Observable<Bool>
    func update<T: Storable>(_ object: T) -> Observable<Bool>
    func delete<T: Storable>(_ object: T) -> Observable<Bool>
}

typealias Storage = ReadableStorage & WriteableStorage
