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
    }

    func test_signIn_andRestartTheApp_keepsSignedIn() {
        // given
        app.launch(options: [.stub(.networkRequests, in: self), .customDataStore(name: name), .cleanKeychain])

        app.signIn()
        Navigation.openAccountView(app:app)

        // when
        app.restart(cleanLaunchOptions: [.cleanKeychain])

        // then
        Navigation.openAccountView(app:app)
    }

    func test_signIn_withInvalidCredentials_remembersUsername() {
        // given
        app.launch(options: [.stub(.networkRequests, in: self), .customDataStore(name: name)])

        app.signInWithInvalidCredentials()
        app.buttons["Ok"].tap()

        // when
        app.restart()

        // then
        let usernameTextField = app.textFields["123456789"]
        wait(forElement: usernameTextField, timeout: 5)
    }
}
