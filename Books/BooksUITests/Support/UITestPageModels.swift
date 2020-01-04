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

        XCUIDevice.shared.press(XCUIDevice.Button.home)

        // UserDefaults need some time when asynchronously persisting data so that other processes can access them.
        let someTime = XCTestExpectation(description: "wait...")
        XCTWaiter().wait(for: [someTime], timeout: 2)

        if cleanLaunchArguments {
            launchArguments.removeAll()
        }

        launch()
    }
}

extension XCUIApplication {

    /// Signs in with matching credentials
    func signIn(_ username: String? = "123456789") {
        if let username = username {
            let usernameTextField = textFields["username"]
            usernameTextField.tap()
            usernameTextField.typeText(username)
        }

        let passwordTextField = textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("***")

        buttons["Sign in"].tap()
    }

    /// Attempts a sign in with invalid credentials
    func signInWithInvalidCredentials() {

        let usernameTextField = textFields.matching(identifier: "username").element
        usernameTextField.tap()
        usernameTextField.typeText("123456789")

        let passwordTextField = textFields.matching(identifier: "password").element
        passwordTextField.tap()
        passwordTextField.typeText("***")

        buttons["Sign in"].tap()
    }
}
