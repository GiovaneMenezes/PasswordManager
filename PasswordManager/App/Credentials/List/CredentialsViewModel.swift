//
//  SitePasswordViewModel.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

struct CredentialsViewModel {

    // MARK: Init
    private let sceneCoordinator: SceneCoordinatorType
    private let session: SessionType
    let logoLoader: ImageLoaderType

    // MARK: Input

    // MARK: Output
    var credentials = BehaviorSubject<[CredentialType]>(value: [])

    // MARK: Properties
    private var currentUser: UserType {
        return session.currentUser!
    }

    init(sceneCoordinator: SceneCoordinatorType, logoLoader: ImageLoaderType, session: SessionType = UserDefaults.standard) {
        self.logoLoader = logoLoader
        self.sceneCoordinator = sceneCoordinator
        self.session = session
        loadItems()
    }

    func onSaveNewItem() -> CompletableAction<(String, String, String)> {
        return Action { server, account, password in
            do {
                let creator = self.currentUser.email
                let item = KeychainPasswordItem(server: server,account: account, creator: creator)
                try item.savePassword(password)
                self.loadItems()
            } catch {
                return Observable.error(error)
            }
            return self.sceneCoordinator.pop().asObservable()
        }
    }

    func onSaveExistingItem(
        _ originalServerName: String,
        _ originalAccountName: String) -> CompletableAction<(String, String, String)> {
        return Action { newServerName, newAccountName, password in
            do {
                let creator = self.currentUser.email
                var item = KeychainPasswordItem(server: originalServerName, account: originalAccountName, creator: creator)
                try item.update(newServerName, newAccountName)
                self.loadItems()
            } catch {
                return Observable.error(error)
            }
            return self.sceneCoordinator.pop().asObservable()
        }
    }

    func deleteAction(credential: CredentialType) -> CocoaAction {
        return CocoaAction {
            do {
                try credential.deleteItem()
                self.loadItems()
            } catch {
                return Observable.error(error)
            }
            return self.sceneCoordinator.pop().asObservable().map { _ in }
        }
    }

    lazy var addAction: CocoaAction = { this in
        return CocoaAction {
            let credentialDetailsViewModel = EditCredentialViewModel(credential: nil, sceneCoordinator: this.sceneCoordinator, saveAction: this.onSaveNewItem())
            return this.sceneCoordinator.transition(to: Scene.editCredential(credentialDetailsViewModel), type: .modal)
                .asObservable()
                .map { _ in }
        }
    }(self)

    lazy var editAction: CompletableAction<CredentialType> = { this in
        return CompletableAction { credential in
            let credentialDetailsViewModel = EditCredentialViewModel(credential: credential, sceneCoordinator: this.sceneCoordinator, saveAction: this.onSaveExistingItem(credential.service, credential.account), deleteAction: this.deleteAction(credential: credential))
            return this.sceneCoordinator.transition(to: Scene.editCredential(credentialDetailsViewModel), type: .modal)
                .asObservable()
        }
    }(self)

    private func loadItems() {
        let items = try! KeychainPasswordItem.passwordItems(forCreator: session.currentUser!.email)
        credentials.onNext(items)
    }


}
