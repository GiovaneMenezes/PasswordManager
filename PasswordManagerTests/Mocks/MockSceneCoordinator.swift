//
//  MockSceneCoordinator.swift
//  PasswordManagerTests
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
@testable import PasswordManager
import RxSwift

struct MockSceneCoordinator: SceneCoordinatorType {

    func pop(animated: Bool) -> Completable {
        return Observable<Never>.empty().ignoreElements()
    }

    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        return Observable<Any>.empty().ignoreElements()
    }

}
