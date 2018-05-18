//
//  PasswordDetailsViewModel.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa

struct EditCredentialViewModel {

    // MARK: Init
    let sceneCoordinator: SceneCoordinatorType
    let saveAction: CompletableAction<(String, String, String)>
    let deleteAction: CocoaAction?

    // MARK: Input
    var siteUrlInput = BehaviorSubject<String>(value: "")
    var usernameInput = BehaviorSubject<String>(value: "")
    var passwordInput = BehaviorSubject<String>(value: "")

    // MARK: Output
    var siteUrl: String = ""
    var username: String = ""
    var password: String = ""
    var shouldShowDeleteButton: Driver<Bool>
    let isSaveButtonEnabled: Driver<Bool>

    init(credential: CredentialType?, sceneCoordinator: SceneCoordinatorType, saveAction: CompletableAction<(String, String, String)>, deleteAction: CocoaAction? = nil) {
        self.sceneCoordinator = sceneCoordinator
        self.saveAction = saveAction
        self.deleteAction = deleteAction

        if let credential = credential {
            siteUrl = credential.service
            username = credential.account
            password = (try? credential.readPassword()) ?? ""
            shouldShowDeleteButton = Driver.just(true)
        } else {
            shouldShowDeleteButton = Driver.just(false)
        }

        isSaveButtonEnabled = Observable.combineLatest(siteUrlInput, usernameInput, passwordInput)
            .map { !$0.isEmpty && !$1.isEmpty && !$2.isEmpty }
            .asDriver(onErrorJustReturn: false)
    }

    func onCancel() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop().asObservable().map { _ in }
        }
    }

}
