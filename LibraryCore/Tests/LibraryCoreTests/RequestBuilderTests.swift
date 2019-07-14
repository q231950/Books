//
//  RequestBuilderTests.swift
//  LibraryCoreTests
//
//  Created by Martin Kim Dung-Pham on 09.09.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import XCTest
@testable import LibraryCore

class RequestBuilderTests: XCTestCase {

    let requestBuilder = RequestBuilder.default

    func testSessionIdentifierRequest() {
        let request = requestBuilder.sessionIdentifierRequest(accountIdentifier: "111111", password: "abc")
        let expectedBody = publicAccessTokenRequestBody.data(using: .utf8)
        var expectedRequest = URLRequest(url: URL(string: "https://zones.buecherhallen.de/app_webuser/WebUserSvc.asmx")!)
        expectedRequest.httpMethod = "POST"
        expectedRequest.httpBody = expectedBody
        expectedRequest.allHTTPHeaderFields = ["Content-Type":"text/xml; charset=utf-8",
                                               "SOAPAction":"http://bibliomondo.com/websevices/webuser/CheckBorrower",
                                               "Accept":"*/*",
                                               "Accept-Language":"en-us",
                                               "Accept-Encoding":"br, gzip, deflate"]
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(expectedRequest.httpBody, request?.httpBody)
    }

    func testAccountRequest() {
        let request = requestBuilder.accountRequest(sessionIdentifier: "35B893D356E3353DA5F67DA0FAFCEEA7")
        let expectedBody = publicAccountRequestBody.data(using: .utf8)
        var expectedRequest = URLRequest(url: URL(string: "https://zones.buecherhallen.de/app_webuser/WebUserSvc.asmx")!)
        expectedRequest.httpMethod = "POST"
        expectedRequest.httpBody = expectedBody
        expectedRequest.allHTTPHeaderFields = ["Content-Type":"text/xml; charset=utf-8",
                                               "SOAPAction":"http://bibliomondo.com/websevices/webuser/GetBorrowerAccount",
                                               "Accept":"*/*",
                                               "Accept-Language":"en-us",
                                               "Accept-Encoding":"br, gzip, deflate"]
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(expectedRequest.httpBody, request?.httpBody)
    }

    func testLoansRequest() {
        let request = requestBuilder.loansRequest(sessionIdentifier: "35B893D356E3353DA5F67DA0FAFCEEA7")
        let expectedBody = publicLoansRequestBody.data(using: .utf8)
        var expectedRequest = URLRequest(url: URL(string: "https://zones.buecherhallen.de/app_webuser/WebUserSvc.asmx")!)
        expectedRequest.httpMethod = "POST"
        expectedRequest.httpBody = expectedBody
        expectedRequest.allHTTPHeaderFields = ["Content-Type":"text/xml; charset=utf-8",
                                               "SOAPAction":"http://bibliomondo.com/websevices/webuser/GetBorrowerLoans",
                                               "Accept":"*/*",
                                               "Accept-Language":"en-us",
                                               "Accept-Encoding":"br, gzip, deflate"]
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(expectedRequest.httpBody, request?.httpBody)
    }

    func testCreditsRequest() {
        let request = requestBuilder.creditsRequest(sessionIdentifier: "35B893D356E3353DA5F67DA0FAFCEEA7")
        let expectedBody = publicCreditsRequestBody.data(using: .utf8)
        var expectedRequest = URLRequest(url: URL(string: "https://zones.buecherhallen.de/app_webuser/WebUserSvc.asmx")!)
        expectedRequest.httpMethod = "POST"
        expectedRequest.httpBody = expectedBody
        expectedRequest.allHTTPHeaderFields = ["Content-Type":"text/xml; charset=utf-8",
                                               "SOAPAction":"http://bibliomondo.com/websevices/webuser/GetBorrowerCredits",
                                               "Accept":"*/*",
                                               "Accept-Language":"en-us",
                                               "Accept-Encoding":"br, gzip, deflate"]
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(expectedRequest.httpBody, request?.httpBody)
    }

    func testRenewRequest() {
        let request = requestBuilder.renewRequest(sessionIdentifier: "35B893D356E3353DA5F67DA0FAFCEEA7", itemIdentifier: "M59 581 999 1")
        let expectedBody = publicRenewRequestBody.data(using: .utf8)
        var expectedRequest = URLRequest(url: URL(string: "https://zones.buecherhallen.de/app_webuser/WebUserSvc.asmx")!)
        expectedRequest.httpMethod = "POST"
        expectedRequest.httpBody = expectedBody
        expectedRequest.allHTTPHeaderFields = ["Content-Type":"text/xml; charset=utf-8",
                                               "SOAPAction":"http://bibliomondo.com/websevices/webuser/RenewItem",
                                               "Accept":"*/*",
                                               "Accept-Language":"en-us",
                                               "Accept-Encoding":"br, gzip, deflate"]
        XCTAssertEqual(request, expectedRequest)
    }

    func testItemDetailsRequest() {
        let request = requestBuilder.itemDetailsRequest(itemIdentifier: "T019556885")
        let expectedBody = publicLoanDetailRequestBody.data(using: .utf8)
        var expectedRequest = URLRequest(url: URL(string: "https://zones.buecherhallen.de/WebCat/WebCatalogueSvc.asmx")!)
        expectedRequest.httpMethod = "POST"
        expectedRequest.httpBody = expectedBody
        expectedRequest.allHTTPHeaderFields = ["Content-Type":"text/xml; charset=utf-8",
                                               "SOAPAction":"http://bibliomondo.com/websevices/webcatalogue/GetCatalogueRecord",
                                               "Accept":"*/*",
                                               "Accept-Language":"en-us",
                                               "Accept-Encoding":"br, gzip, deflate"]
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(expectedRequest.httpBody, request?.httpBody)
    }
}
