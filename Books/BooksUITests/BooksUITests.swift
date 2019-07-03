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
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        let p = ProcessInfo()

        app.launchEnvironment["TESTING"] = p.environment["TESTING"]

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
