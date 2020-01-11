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
        app.signIn()

        let listItemIdentifier = app.buttons["T014940950"]
        _ = listItemIdentifier.waitForExistence(timeout: 3)
    }

    func test_renewalShowsError() {
        app.signIn()

        let listItemIdentifier = app.buttons["T014940950"]
        listItemIdentifier.tap()

        let renewButton = app.buttons["Renew"]
        renewButton.tap()


        let renewedText = app.buttons["Not renewed"]
        renewedText.waitForExistence(timeout: 500)
    }

    func test_renewal_renews() {
        app.signIn()

        let listItemIdentifier = app.buttons["T014940950"]
        listItemIdentifier.tap()

        let renewButton = app.buttons["Renew"]
        renewButton.tap()


        let renewedText = app.buttons["Renewed"]
        renewedText.waitForExistence(timeout: 500)
    }
}
