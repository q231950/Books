//
//  AccountUITests.swift
//  BooksUITests
//
//  Created by Martin Kim Dung-Pham on 12.11.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import XCTest

class AccountUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()

        let processInfo = ProcessInfo()
        app.launchEnvironment["STUB_PATH"] = "\(processInfo.environment["PROJECT_DIR"] ?? "")/BooksUITests/Stubs"
        app.launchEnvironment["THE_STUBBORN_NETWORK_UI_TESTING"] = "YES"
        app.launchEnvironment["STUB_NAME"] = self.name

        app.launchArguments.append("clean")

        app.launch()
    }

    func testSignOutButton() {
        // given
        SignInView.signIn(app:app)

        // when
        Navigation.openAccountView(app:app)

        // then
        let signOutLabel = app.buttons["Sign out"]
        wait(forElement:signOutLabel, timeout:5)
    }

    func testSignOutAllowsNewSignIn() {
        // given
        SignInView.signIn(app:app)

        // when
        Navigation.openAccountView(app:app)

        // then
        let signOutLabel = app.buttons["Sign out"]
        signOutLabel.tap()

        let signInLabel = app.buttons["Sign in"]
        wait(forElement:signInLabel, timeout:5)
    }
}
