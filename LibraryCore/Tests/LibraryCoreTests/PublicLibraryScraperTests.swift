//
//  PublicLibraryScraperTests.swift
//  LibraryCoreTests
//
//  Created by Martin Kim Dung-Pham on 14.10.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import XCTest
import StubbornNetwork
@testable import LibraryCore

class PublicLibraryScraperTests: XCTestCase {

    let stubbedURLSession = StubbornNetwork.makeEphemeralSession()
    let keychainMock = TestHelper.keychainMock
    var account: Account!
    var network: NetworkClient!
    var scraper: PublicLibraryScraper!

    override func setUp() {
        super.setUp()
        account = Account()
        network = NetworkClient(session: stubbedURLSession)
        scraper = PublicLibraryScraper(network: network, keychainProvider: keychainMock)
        account.username = "123"
        try! keychainMock.add(password: "abc", to: account.username)
    }

    func testAccount() throws {
        let exp = expectation(description: "Account completion")
        let request = try XCTUnwrap(RequestBuilder().accountRequest(sessionIdentifier: "abc"))
        let data = publicAccountResponseBody.data(using: .utf8)
        stubbedURLSession.stub(request, data: data, response: nil, error: nil)
        scraper.charges(account: account, sessionIdentifier: "abc") { (error, charges) -> (Void) in
            let dateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(identifier: "Europe/Berlin"), year: 2018, month: 9, day: 20)

            XCTAssertEqual(charges.first?.amount, 1.0)
            XCTAssertEqual(charges.first?.reason, "Vormerkgebühr")
            XCTAssertEqual(charges.first?.date, dateComponents.date)
            XCTAssertEqual(charges.first?.endDate, nil)

            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.01)
    }

    func testLoans() throws {
        let exp = expectation(description: "Loans completion")
        let request = try XCTUnwrap(RequestBuilder().loansRequest(sessionIdentifier: "abc"))
        stubbedURLSession.stub(request, data: publicLoansResponseBody, response: nil, error: nil)
        scraper.loans(account, authenticationManager: AuthenticationManager.stubbed({ (manager) in
            manager.authenticated = true
            manager.stubbedSessionIdentifier = "123-abc"
        })) { (error, loans) -> (Void) in
            XCTAssertEqual(loans.count, 2)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
