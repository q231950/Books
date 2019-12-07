//
//  UITestPageModels.swift
//  BooksUITests
//
//  Created by Martin Kim Dung-Pham on 12.11.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import XCTest

class Navigation {
    static func openAccountView(app: XCUIApplication) {
        let tabbarButtons = app.tabBars.buttons
        let accountButton = tabbarButtons["Account"]

        accountButton.tap()
    }
}

extension XCUIApplication {

    /// Restarts the application by terminating and activating it again
    /// - Parameters:
    ///   - cleanLaunchArguments: Before activating the app `cleanLaunchArguments` defines whether or not all its previous launch arguments
    ///                           should be cleared
    func restart(cleanLaunchArguments: Bool = true) {
        terminate()

        if cleanLaunchArguments {
            launchArguments.removeAll()
        }

        activate()
    }
}

extension XCUIApplication {

    /// Signs in with matching credentials
    func signIn() {
        let usernameTextField = textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText("123456789")

        let passwordTextField = textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("***")

        buttons["Sign in"].tap()
    }

    /// Attempts a sign in with invalid credentials
    func signInWithInvalidCredentials(username: String) {
        let usernameTextField = textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText(username)

        let passwordTextField = textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("123")

        buttons["Sign in"].tap()
    }
}
