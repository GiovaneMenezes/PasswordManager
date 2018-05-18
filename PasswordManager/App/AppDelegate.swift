//
//  AppDelegate.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 16/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import UIKit
import NSObject_Rx
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let disposeBag = DisposeBag()
    var sceneCoordinator: SceneCoordinator!
    var biometricHandler: BiometricAuthHandlerType!
    var session: SessionType = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        sceneCoordinator = SceneCoordinator(window: window!)
        biometricHandler = BiometricIDAuth()

        if session.isLoggedIn {
            session.setAppLocked(value: false)

            let credentialsViewModel = CredentialsViewModelFactory.create(sceneCoordinator: sceneCoordinator)
            let credetialsScene = Scene.credentials(credentialsViewModel)
            sceneCoordinator.transition(to: credetialsScene, type: .root)
            
        } else {
            let signInCoordinator = SignInCoordinator(signInService: SignInNetworkService())
            let signInViewModel = SignInViewModel(signInCoordinator: signInCoordinator, sceneCoordinator: sceneCoordinator)
            let signInScene = Scene.signIn(signInViewModel)
            sceneCoordinator.transition(to: signInScene, type: .root)
        }
        printRxResources()
        return true
    }

    func printRxResources() {
        #if DEBUG
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .subscribe({ _ in
                print("Resource count \(RxSwift.Resources.total)")
            })
        #endif
    }

    func goToAppLocked() {
        if !session.isAppLocked {
            session.setAppLocked(value: true)
            let appLockedViewModel = AppLockedViewModel(biometricAuthHandler: biometricHandler, sceneCoordinator: sceneCoordinator)
            sceneCoordinator.transition(to: .appLocked(appLockedViewModel), type: .modal)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        UIApplication.shared.ignoreSnapshotOnNextApplicationLaunch()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        goToAppLocked()
    }



}

