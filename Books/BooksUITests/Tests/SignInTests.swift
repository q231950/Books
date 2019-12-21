//
//  SignInTests.swift
//  BooksUITests
//
//  Created by Martin Kim Dung-Pham on 06.12.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import XCTest

class SignInTests: XCTestCase {
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

    func test_signIn_andRestartTheApp_keepsSignedIn() {
        // given
        app.signIn()
        Navigation.openAccountView(app:app)

        // when
        app.restart()

        // then
        Navigation.openAccountView(app:app)
    }

    func test_signIn_withInvalidCredentials_remembersUsername() {
        // given
        app.signInWithInvalidCredentials()
        app.buttons["Ok"].tap()

        // when
        app.restart()

        // then
        let usernameTextField = app.textFields["123456789"]
        wait(forElement: usernameTextField, timeout: 5)
    }
}
