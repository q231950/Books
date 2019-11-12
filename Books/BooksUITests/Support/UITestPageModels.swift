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

class SignInView {
    static func signIn(app: XCUIApplication) {
        let usernameTextField = app.textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText("123456789")

        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("***")

        // when
        app.buttons["Sign in"].tap()
    }
}
