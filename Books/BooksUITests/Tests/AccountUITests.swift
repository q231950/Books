//
//  AccountUITests.swift
//  BooksUITests
//
//  Created by Martin Kim Dung-Pham on 12.11.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import XCTest
import Rorschach

class AccountUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()

        app.launch(options: [.stub(.networkRequests, in: self), .cleanKeychain, .customDataStore(name: name)])
    }

    func testAccountName() {
        var context = Context(app: app, test: self)
        expect(in: &context) {
            Given {
                GeneralStep("I sign in") {
                    $0.app.signIn()
                }
            }
            When {
                GeneralStep("I open the account view") {
                    Navigation.openAccountView(app: $0.app)
                }
            }
            Then {
                GeneralAssertion("I can see my name") {
                    let nameText = $0.app.staticTexts["my name"]
                    $0.test.wait(forElement:nameText, timeout:2)
                }
            }
        }
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
