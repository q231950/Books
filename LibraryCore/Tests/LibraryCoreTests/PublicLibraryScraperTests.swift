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

    let keychainMock = TestHelper.keychainMock
    var account: Account!
    var network: NetworkClient!
    var scraper: PublicLibraryScraper!
    var stubbornNetwork: StubbornNetwork!

    override func setUp() {
        super.setUp()
        account = Account()
        stubbornNetwork = StubbornNetwork.standard
        let configuration: URLSessionConfiguration = .ephemeral
        stubbornNetwork.insertStubbedSessionURLProtocol(into: configuration)
        let session = URLSession(configuration: configuration)
        network = NetworkClient(session: session)

        scraper = PublicLibraryScraper(network: network, keychainProvider: keychainMock)
        account.username = "123"
        try! keychainMock.add(password: "abc", to: account.username)
    }

    func testAccount() throws {
        let exp = expectation(description: "Account completion")
        let request = try XCTUnwrap(RequestBuilder().accountRequest(sessionIdentifier: "abc"))
        let data = publicAccountResponseBody.data(using: .utf8)
        stubbornNetwork.stub(request: request, data: data)
        scraper.charges(account: account, sessionIdentifier: "abc") { (error, charges) -> (Void) in
            let dateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(identifier: "Europe/Berlin"), year: 2018, month: 9, day: 20)
            XCTAssertEqual(charges.first?.amount, 1.0)
            XCTAssertEqual(charges.first?.reason, "Vormerkgebühr")
            XCTAssertEqual(charges.first?.date, dateComponents.date)
            XCTAssertEqual(charges.first?.endDate, nil)

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    func test_publicLibraryScraper_loadsLoans() throws {
        let exp = expectation(description: "Loans completion")
        let request = try XCTUnwrap(RequestBuilder().loansRequest(sessionIdentifier: "abc"))
        stubbornNetwork.stub(request: request, data: publicLoansResponseBody)

        let loanDetailRequest = try XCTUnwrap(RequestBuilder.default.itemDetailsRequest(itemIdentifier: "T01540384X"))
        stubbornNetwork.stub(request: loanDetailRequest, data: publicLoanDetailResponseBody)

        let loanDetailRequestB = try XCTUnwrap(RequestBuilder.default.itemDetailsRequest(itemIdentifier: "T01684642X"))
        stubbornNetwork.stub(request: loanDetailRequestB, data: publicLoanDetailResponseBody)
        scraper.loans(account, authenticationManager: AuthenticationManager.stubbed({ (manager) in
            manager.authenticated = .authenticationComplete(.authenticated)
            manager.stubbedSessionIdentifier = "abc"
        })) { (error, loans) -> (Void) in
            XCTAssertEqual(loans.count, 2)
            XCTAssertEqual(loans.first?.identifier, "T01540384X")
            XCTAssertEqual(loans.first?.signature, "Jd 0#FERG•/21 Jd 0")
            XCTAssertEqual(loans.first?.author, "Ferguson Smart, John")
            XCTAssertEqual(loans.first?.title, "Jenkins: the definitive guide")
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
