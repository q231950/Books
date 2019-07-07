//
//  PublicLibraryScraperTests.swift
//  LibraryCoreTests
//
//  Created by Martin Kim Dung-Pham on 14.10.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import XCTest
@testable import LibraryCore

class PublicLibraryScraperTests: XCTestCase {

    let networkMock = TestHelper.networkMock
    let keychainMock = TestHelper.keychainMock
    var account: Account!
    var scraper: PublicLibraryScraper!

    override func setUp() {
        super.setUp()
        account = Account()
        scraper = PublicLibraryScraper(network: networkMock, keychainProvider: keychainMock)
        account.username = "123"
        try! keychainMock.add(password: "abc", to: account.username)
    }

    func testAccount() {
        let exp = expectation(description: "Account completion")
        let request = RequestBuilder().accountRequest(sessionIdentifier: "abc")
        let data = publicAccountResponseBody.data(using: .utf8)
        networkMock.stub(for: request!, data: data, response: nil, error: nil)
        scraper.charges(account: account, sessionIdentifier: "abc") { (error, charges) -> (Void) in
            let dateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone.current, year: 2018, month: 9, day: 20)

            XCTAssertEqual(charges.first?.amount, 1.0)
            XCTAssertEqual(charges.first?.reason, "Vormerkgebühr")
            XCTAssertEqual(charges.first?.date, dateComponents.date)
            XCTAssertEqual(charges.first?.endDate, nil)

            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.01)
    }

    func testLoans() {
        let exp = expectation(description: "Loans completion")
        let request = RequestBuilder().loansRequest(sessionIdentifier: "abc")
        networkMock.stub(for: request!, data: publicLoansResponseBody, response: nil, error: nil)
        scraper.loans(account, sessionIdentifier: "abc") { (error, loans) -> (Void) in
            XCTAssertEqual(loans.count, 2)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
