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

        wait(forElement: app.buttons["T016637199"], timeout: 3)
    }

    func test_renewalShowsError() {
        app.signIn()

        let listItemIdentifier = app.buttons["T014940950"]
        listItemIdentifier.tap()

        let renewButton = app.buttons["Renew"]
        renewButton.tap()

        wait(forElement: app.staticTexts["Not Renewed"], timeout: 2)
    }

    func test_renewal_renews() {
        app.signIn()

        let listItemIdentifier = app.buttons["T017285249"]
        listItemIdentifier.tap()

        let renewButton = app.buttons["Renew"]
        renewButton.tap()

        wait(forElement: app.staticTexts["Renewed"], timeout: 2)
    }

    func test_loanDetails_showInformation() {
        app.signIn()

        let newAtlantisLoan = app.buttons["T019605398"]
        newAtlantisLoan.tap()

        wait(forElement: app.staticTexts["Salty Days"], timeout: 1)
        wait(forElement: app.staticTexts["Smallpeople"], timeout: 1)
        wait(forElement: app.staticTexts["muc R 2 SMAL Rock, Pop"], timeout: 1)
        wait(forElement: app.staticTexts["Vinyl"], timeout: 1)
        wait(forElement: app.staticTexts["14.02.2020"], timeout: 1)
        wait(forElement: app.staticTexts["13.03.2020"], timeout: 1)
    }

    func test_neverRenewed_showsNeverRenewed() {
        app.signIn()

        let secondLoan: XCUIElement = app.cells.element(boundBy: 1)
        secondLoan.tap()

        wait(forElement: app.staticTexts["never renewed"], timeout: 1)
    }
}
