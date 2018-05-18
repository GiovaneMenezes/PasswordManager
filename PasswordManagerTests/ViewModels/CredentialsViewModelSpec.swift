//
//  CredentialsViewModelSpec.swift
//  PasswordManagerTests
//
//  Created by Caio Sanchez Santos Costa on 18/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxCocoa
import Action
import RxTest
import RxBlocking
import RxNimble

@testable import PasswordManager

func createCredentialsViewModel() -> CredentialsViewModel {
    let sceneCoordinator = MockSceneCoordinator()
    let imageLoader = MockImageLoader()
    let session = MockUserDefaults()
    session.saveUser(Seed.user)
    let viewModel = CredentialsViewModel(
        sceneCoordinator: sceneCoordinator,
        logoLoader: imageLoader,
        session: session)
    return viewModel
}

class CredentialsViewModelSpec: QuickSpec {

    override func spec() {

        describe("CredentialsViewModel") {

            var viewModel: CredentialsViewModel!

            beforeEach {
                Seed.credentials.forEach { try! $0.savePassword("Senha@1234") }
                viewModel = createCredentialsViewModel()
            }

            afterEach {
                try! KeychainPasswordItem.deleteAll()
            }

            it("should list saved credentials") {
                let savedCredentials = try! viewModel.credentials.toBlocking().first() as! [KeychainPasswordItem]
                expect(savedCredentials).to(equal(Seed.credentials))
            }

            it("should show logo for credential url") {
                let logo = viewModel.logoLoader.loadImage(from: Seed.credentials.first!.server).asObservable()
                expect(logo).first.toNot(beNil())
            }

        }
    }
}

//func ==<T: CredentialType>(lhs: T, rhs: T) -> Bool {
//    return lhs.server == rhs.server && lhs.account == rhs.account && lhs.server == rhs.server
//}

