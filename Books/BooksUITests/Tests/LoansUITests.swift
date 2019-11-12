//
//  LoansUITests.swift
//  BooksUITests
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import XCTest
@testable import Books

class LoansUITests: XCTestCase {

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
        SignInView.signIn(app:app)

        // then
        let label = app.staticTexts["🌊"]
        wait(forElement:label, timeout:5)
    }
}
