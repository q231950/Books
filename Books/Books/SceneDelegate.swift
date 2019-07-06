//
//  SceneDelegate.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import UIKit
import SwiftUI
import LibraryCore

struct Environment {
    static var testing: Bool {
        get {
            let p = ProcessInfo()
            let testingAsString = p.environment["TESTING"]
            return testingAsString != nil
        }
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let window = UIWindow(frame: UIScreen.main.bounds)

        let authenticationViewModel = createAuthenticationViewModel()
        let accountViewModel = AccountViewModel(account: Account())

        window.rootViewController = UIHostingController(rootView: ContentView(authentication: authenticationViewModel, account:accountViewModel))

        self.window = window
        window.makeKeyAndVisible()
    }

    ///
    /// Create an authentication view model
    ///
    /// The Authentication View Model will use a stubbed authentication manager during testing
    ///
    private func createAuthenticationViewModel() -> AuthenticationViewModel {
        #if DEBUG
        if Environment.testing {
            let authenticationManagerStub = AuthenticationManager.stubbed {
                $0.authenticated = true
            }

            return AuthenticationViewModel(authenticationManager: authenticationManagerStub)
        }
        #endif
        return AuthenticationViewModel(authenticationManager: AuthenticationManager.shared)
    }
}

