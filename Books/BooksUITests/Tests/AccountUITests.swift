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

        app.launch(options: [.stub(.networkRequests, in: self), .cleanKeychain, .customDataStore(name: name)])
    }

    func testSignOutButton() {
        // given
        app.signIn()

        // when
        Navigation.openAccountView(app:app)

        // then
        let signOutLabel = app.buttons["Sign out"]
        wait(forElement:signOutLabel, timeout:5)
    }

    func testSignOutAllowsNewSignIn() {
        // given
        app.signIn()

        // when
        Navigation.openAccountView(app:app)

        // then
        app.buttons["Sign out"].tap()

        let signInLabel = app.buttons["Sign in"]
        wait(forElement:signInLabel, timeout:5)
    }

    func test_SignOut_showsAlertWhenSuccessful() {
        // given
        app.signIn()

        // when
        Navigation.openAccountView(app:app)

        // then
        app.buttons["Sign out"].tap()

        let signOutSuccess = app.staticTexts["You are now signed out"]
        wait(forElement:signOutSuccess, timeout:5)
    }
}
