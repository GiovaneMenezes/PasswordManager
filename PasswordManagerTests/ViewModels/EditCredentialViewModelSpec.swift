//
//  EditCredentialViewModelSpec.swift
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
import RxNimble

@testable import PasswordManager

class EditCredentialViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("EditCredentialViewModel") {
            
            afterEach {
                try! KeychainPasswordItem.deleteAll()
            }
            
            
            it("should save new credential") {
                
                let viewModel = EditCredentialViewModel(credential: nil, sceneCoordinator: MockSceneCoordinator(), saveAction: createCredentialsViewModel().onSaveNewItem())
                let credentialToSave = Seed.credentials.first!
                
                let passwordToSave = "Senha@4321"
                
                viewModel.saveAction
                    .execute((credentialToSave.server, credentialToSave.account, passwordToSave))
                let item = try! KeychainPasswordItem.passwordItems(forCreator: Seed.user.email)
                
                expect(item).to(equal([credentialToSave]))
                
                let savedPassword = try! item.first!.readPassword()
                
                expect(savedPassword).to(equal(passwordToSave))
            }
            
            
            it("should allow edit a saved credential") {
                let credential = Seed.credentials[1]
                let savedPassword = "4321@Senha"
                try! credential.savePassword(savedPassword)
                
                let viewModel = EditCredentialViewModel(credential: credential, sceneCoordinator: MockSceneCoordinator(), saveAction: createCredentialsViewModel().onSaveExistingItem(credential.server, credential.account))
                
                let newServerName = "newServer.com"
                let newAccount = "newAccount@account.com"
                let newPassword = "newPassword@1234"
                let input = (newServerName, newAccount, newPassword)
                
                viewModel.saveAction.execute(input)
                
                let editedCredential = try! KeychainPasswordItem.passwordItems(forCreator: Seed.user.email)[0]
                let editedPassword = try! editedCredential.readPassword()
                expect(editedCredential.server).to(equal(newServerName))
                expect(editedCredential.account).to(equal(newAccount))
                expect(editedPassword).to(equal(newPassword))
                expect(editedCredential.creator).to(equal(Seed.user.email))
                
            }
            
        }
    }
}
