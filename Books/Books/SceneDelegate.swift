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

        let authenticationViewModel: AuthenticationViewModel

        if Environment.testing {
            print("Test run")
            let authenticationManagerMock = AuthenticationManager.mocked
            authenticationViewModel = AuthenticationViewModel(authenticationManager: authenticationManagerMock)
        } else {
            print("Production run")
            authenticationViewModel = AuthenticationViewModel(authenticationManager: AuthenticationManager.shared)
        }

        let accountViewModel = AccountViewModel(account: Account())

        window.rootViewController = UIHostingController(rootView: ContentView(authentication: authenticationViewModel, account:accountViewModel))

        self.window = window
        window.makeKeyAndVisible()
    }
}

