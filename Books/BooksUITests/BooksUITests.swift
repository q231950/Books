//
//  BooksUITests.swift
//  BooksUITests
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import XCTest
@testable import Books

class BooksUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        let p = ProcessInfo()

        app.launchEnvironment["TESTING"] = p.environment["TESTING"]

        app.launch()
    }

    func testWaveVisibleAfterSignIn() {
        // given
        let usernameTextField = app.textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText("123456789")

        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("abcd")

        // when
        app.buttons["Sign in"].tap()

        // then
        let label = app.staticTexts["🌊"] /// <<< expectation to see 🌊🌊🌊
        let predicate = NSPredicate(format: "exists == true")
        expectation(for: predicate, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 1, handler: nil)
    }

}
