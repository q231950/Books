//
//  AuthenticationManagerTest.swift
//  BTLBTests
//
//  Created by Martin Kim Dung-Pham on 08.09.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import XCTest
@testable import LibraryCore

class AuthenticationManagerTest: XCTestCase {

    let networkMock = TestHelper.networkMock
    let keychainMock = TestHelper.keychainMock
    var account: Account!

    override func setUp() {
        super.setUp()
        account = TestHelper.accountStub()
    }

    func testAuthenticationRequest() throws {
        let exp = expectation(description: "wait for async")
        var expectedRequest = URLRequest(url: URL(string: "https://zones.buecherhallen.de/app_webuser/WebUserSvc.asmx")!)
        expectedRequest.httpMethod = "POST"
        expectedRequest.allHTTPHeaderFields = ["Content-Type":"text/xml; charset=utf-8",
                                               "SOAPAction":"http://bibliomondo.com/websevices/webuser/CheckBorrower",
                                               "Accept":"*/*",
                                               "Accept-Language":"en-us",
                                               "Accept-Encoding":"br, gzip, deflate"]
        networkMock.expectRequest(expectedRequest)
        account.username = "123"
        try keychainMock.add(password: "abc", to: "123")
        let authenticationManager = AuthenticationManager(network: networkMock, keychainManager: keychainMock)
        authenticationManager.authenticateAccount("123", completion: { (_, _) in
            exp.fulfill()
        })

        wait(for: [exp], timeout: 0.1)

        try networkMock.verifyRequests(test: self)
    }

    func testValidAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let data = publicSessionIdentifierResponseBody.data(using: .utf8)
        networkMock.stub(data: data, response: nil, error: nil)
        account.username = "123"
        let credentialStore = AccountCredentialStore(keychainProvider: keychainMock)
        try credentialStore.store("abc", of: "123")
        let authenticationManager = AuthenticationManager(network: networkMock, keychainManager: keychainMock)
        authenticationManager.authenticateAccount("123") { (authenticated, error) in
            XCTAssertTrue(authenticated)
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testInvalidAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let data = publicAccessTokenRequestBody.data(using: .utf8)
        networkMock.stub(data: data, response: nil, error: nil)
        account.username = "123"
        let credentialStore = AccountCredentialStore(keychainProvider: keychainMock)
        try credentialStore.store("abc", of: "123")
        let authenticationManager = AuthenticationManager(network: networkMock, keychainManager: keychainMock)
        authenticationManager.authenticateAccount("123") { (authenticated, error) in
            XCTAssertFalse(authenticated)
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testErronousAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let expectedError = NSError(domain: "com.elbedev.test", code: 1)
        networkMock.stub(data: nil, response: nil, error: expectedError)
        account.username = "123"
        let credentialStore = AccountCredentialStore(keychainProvider: keychainMock)
        try credentialStore.store("abc", of: "123")
        let authenticationManager = AuthenticationManager(network: networkMock, keychainManager: keychainMock)
        authenticationManager.authenticateAccount("123") { (authenticated, error) in
            XCTAssertFalse(authenticated)
            XCTAssertEqual(error, expectedError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testErrorWhenMissingAccountIdentifierAndPassword() {
        let exp = expectation(description: "wait for async")
        let authenticationManager = AuthenticationManager(network: networkMock, keychainManager: keychainMock)
        account = TestHelper.accountStub()
        authenticationManager.authenticateAccount("123") { (_, error) in
            XCTAssertEqual(error, NSError.missingPasswordError())
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testErrorWhenMissingPassword() {
        let exp = expectation(description: "wait for async")
        let authenticationManager = AuthenticationManager(network: networkMock, keychainManager: keychainMock)
        account = TestHelper.accountStub()
        account.username = "user id"
        authenticationManager.authenticateAccount("user id") { (_, error) in
            XCTAssertEqual(error?.localizedDescription, "Authentication failed")
            XCTAssertEqual(error?.localizedFailureReason, "Please enter your password.")
            XCTAssertNil(error?.localizedRecoverySuggestion)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
}
