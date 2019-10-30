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

            let authenticationViewModel = createAuthenticationViewModel()
            let accountViewModel = AccountViewModel(account: Account())
            let contentView = ContentView(authenticationViewModel: authenticationViewModel, account:accountViewModel)
            let hostingController = UIHostingController(rootView: contentView)

            window.rootViewController = hostingController

            self.window = window
            window.makeKeyAndVisible()
        }

    }

    /// Create an authentication view model.
    ///
    private func createAuthenticationViewModel() -> AuthenticationViewModel {
        return AuthenticationViewModel(authenticationManager: AuthenticationManager.shared)
    }
}
