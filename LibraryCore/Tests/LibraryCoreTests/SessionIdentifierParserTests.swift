//
//  SessionIdentifierParserTests.swift
//  BTLBTests
//
//  Created by Martin Kim Dung-Pham on 19.09.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import XCTest
@testable import LibraryCore

class SessionIdentifierParserTests: XCTestCase {

    let parser = SessionIdentifierParser()

    func testParseAccessToken() {
        let data = publicSessionIdentifierResponseBody.data(using: .utf8)
        let parseResult = parser.parseSessionIdentifier(data: data)
        switch parseResult {
        case .success(let token):
            XCTAssertEqual(token, "3851B8E297C92015FBE3EB3A72D7687B")
        default:
            XCTFail("Failed to parse access token")
        }
    }

    func testAccessTokenNotAvailable() {
        let data = publicAccessTokenRequestBody.data(using: .utf8)
        let parseResult = parser.parseSessionIdentifier(data: data)
        switch parseResult {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Failed to parse access token")
        }
    }

    func testEmptyAccessToken() {
        let parseResult = parser.parseSessionIdentifier(data: nil)
        switch parseResult {
        case .error(let err):
            XCTAssertEqual(err.localizedDescription, "Failed to parse access token. No data to parse.")
        default:
            XCTFail("Failed to parse access token")
        }
    }

    func testInvalidAccessTokenData() {
        let invalidXMLData = "<xml is broken".data(using: .utf8)
        let parseResult = parser.parseSessionIdentifier(data: invalidXMLData)
        switch parseResult {
        case .error(let err):
            XCTAssertEqual(err.localizedDescription, "The operation couldn’t be completed. (NSXMLParserErrorDomain error 41.)")
        default:
            XCTFail("Failed to parse access token")
        }
    }
}
