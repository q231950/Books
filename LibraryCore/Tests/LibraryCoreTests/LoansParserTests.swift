//
//  LoansParserTests.swift
//  LibraryCoreTests
//
//  Created by Martin Kim Dung-Pham on 25.08.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import XCTest
@testable import LibraryCore

class LoansParserTests: XCTestCase {

    var parser = FlamingoLoansParser(baseUrl: URL(string: "elbedev.com")!)
    let data = publicLoansResponseBody

    func testLoansCount() {
        let loans = parser.loans(data: data)
        XCTAssertEqual(2, loans.count)
    }

    func testLoansTitles() {
        let expectedTitles = ["Jenkins: the definitive guide", "iOS Security"]

        let loans = parser.loans(data: data)

        for index in 0..<expectedTitles.count {
            let expectedTitle = expectedTitles[index]
            XCTAssertEqual(loans[index].title, expectedTitle)
        }
    }

    func testLoansDetailURLs() {
        let expectedURLs = ["elbedev.com/suchergebnis-detail/medium/T01540384X.html",
                            "elbedev.com/suchergebnis-detail/medium/T01684642X.html"]

        let loans = parser.loans(data: data)

        for index in 0..<expectedURLs.count {
            let expectedURL = expectedURLs[index]
            XCTAssertEqual(loans[index].detailsUrl?.absoluteString, expectedURL)
        }
    }

    func testLoansTimesProlonged() {
        let expectedTimesProlonged = [1,0]

        let loans = parser.loans(data: data)

        for index in 0..<expectedTimesProlonged.count {
            let expectedCount = expectedTimesProlonged[index]
            XCTAssertEqual(loans[index].timesProlonged, expectedCount)
        }
    }

    func testLoansExpiryDates() {
        let expectedDates = ["06.10.2018", "13.01.2019"]

        let loans = parser.loans(data: data)

        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        df.timeZone = TimeZone(secondsFromGMT: -3600)

        for index in 0..<expectedDates.count {
            let expectedDate = df.date(from: expectedDates[index])
            XCTAssertEqual(loans[index].expiryDate, expectedDate!)
        }
    }

    func testLoansBorrowedDates() {
        let expectedDates = ["08.09.2018", "13.02.2018"]

        let loans = parser.loans(data: data)

        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        df.timeZone = TimeZone(secondsFromGMT: -3600)

        for index in 0..<expectedDates.count {
            let expectedDate = df.date(from: expectedDates[index])
            XCTAssertEqual(loans[index].borrowedDate, expectedDate!)
        }
    }

    func testLoansIdentifiers() {
        let expectedIdentifiers = ["T01540384X", "T01684642X"]
        let loans = parser.loans(data: data)

        for index in 0..<expectedIdentifiers.count {
            let expectedIdentifier = expectedIdentifiers[index]
            XCTAssertEqual(loans[index].identifier, expectedIdentifier)
        }
    }

}
