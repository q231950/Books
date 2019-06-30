//
//  BooksUITests.swift
//  BooksUITests
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import XCTest

class BooksUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWaveVisibleAfterSignIn() {
        let app = XCUIApplication()
        let usernameTextField = app.textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText("123456789")

        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("abcd")

        app.buttons["Sign in"].tap()

        let label = app.staticTexts["🌊"]
        let predicate = NSPredicate(format: "exists == true")
        expectation(for: predicate, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 1, handler: nil)
    }

}
