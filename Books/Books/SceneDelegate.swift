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

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            setUpColors(window: window)

            let authenticationViewModel = createAuthenticationViewModel()
            let contentView = ContentView(authenticationViewModel: authenticationViewModel).environmentObject(authenticationViewModel)
            let hostingController = UIHostingController(rootView: contentView)

            window.rootViewController = hostingController

            self.window = window
            window.makeKeyAndVisible()
        }
    }

    /// Setup the colors for this scene
    private func setUpColors(window: UIWindow) {
        window.tintColor = UIColor(named: "accent")
    }

    /// Create an authentication view model.
    private func createAuthenticationViewModel() -> AuthenticationViewModel {
        var account = AccountModel()
        let store = AccountStore()
        if let identifier = store.defaultAccountIdentifier() {
            account.username = identifier
        }

        let accountViewModel = AccountViewModel(account: account)
        let accountStore = AccountStore()
        return AuthenticationViewModel(authenticationManager: AuthenticationManager(accountStore: accountStore),
                                       accountViewModel: accountViewModel)
    }
}
