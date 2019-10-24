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

        let processInfo = ProcessInfo()
        app.launchEnvironment["STUB_PATH"] = "\(processInfo.environment["PROJECT_DIR"] ?? "")/stubs"
        app.launchEnvironment["THE_STUBBORN_NETWORK_UI_TESTING"] = "YES"
        app.launchEnvironment["STUB_NAME"] = self.name

        app.launch()
    }

    func testSignIn() {
        // given
        let usernameTextField = app.textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText("577544816")

        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("***")

        // when
        app.buttons["Sign in"].tap()

        // then
        let label = app.staticTexts["🌊"]
        wait(forElement:label, timeout:20)
    }
}

extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == true")
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}
