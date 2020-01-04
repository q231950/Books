//
//  LoansUITests.swift
//  BooksUITests
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import XCTest

class LoansUITests: XCTestCase {

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

    func test_loans_areVisible_afterSignIn() {
        // given
        app.signIn()

        // then
        let label1 = app.staticTexts["Parallel and concurrent programming in Haskell"]
        wait(forElement:label1, timeout:2)

        let label2 = app.staticTexts["Haskell-Intensivkurs"]
        wait(forElement:label2, timeout:2)
    }
}
