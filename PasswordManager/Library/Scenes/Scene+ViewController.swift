/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

extension Scene {
    func viewController() -> UIViewController {

        var storyboard: UIStoryboard

        switch self {

        case .signUp(let viewModel):
            storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "SignUp") as! UINavigationController
            var vc = nc.viewControllers.first as! SignUpViewController
            vc.bindViewModel(to: viewModel)
            return nc

        case .signIn(let viewModel):
            storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "SignIn") as! UINavigationController
            var vc = nc.viewControllers.first as! SignInViewController
            vc.bindViewModel(to: viewModel)
            return nc

        case .biometricAuth(let viewModel):
            storyboard = UIStoryboard(name: "BiometricAuth", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "BiometricAuth") as! UINavigationController
            var vc = nc.viewControllers.first as! BiometricAuthViewController
            vc.bindViewModel(to: viewModel)
            return nc

        case .credentials(let viewModel):
            storyboard = UIStoryboard(name: "Credentials", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "Credentials") as! UINavigationController
            var vc = nc.viewControllers.first as! CredentialsViewController
            vc.bindViewModel(to: viewModel)
            return nc

        case .editCredential(let viewModel):
            storyboard = UIStoryboard(name: "EditCredential", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "EditCredential") as! UINavigationController
            var vc = nc.viewControllers.first as! EditCredentialViewController
            vc.bindViewModel(to: viewModel)
            return nc

        case .appLocked(let viewModel):
            storyboard = UIStoryboard(name: "AppLocked", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "AppLocked") as! UINavigationController
            var vc = nc.viewControllers.first as! AppLockedViewController
            vc.bindViewModel(to: viewModel)
            return nc
        }
    }
}
