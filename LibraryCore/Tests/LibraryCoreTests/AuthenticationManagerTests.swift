//
//  AuthenticationManagerTest.swift
//  LibraryCoreTests
//
//  Created by Martin Kim Dung-Pham on 08.09.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import XCTest
import StubbornNetwork
@testable import LibraryCore

class AccountCredentialStoreMock: AccountCredentialStore {
    var didStoreSecretCount = 0
    var didDeleteSecretCount = 0

    override func store(_ password: String, of accountIdentifier: String) throws {
        didStoreSecretCount += 1
        try super.store(password, of: accountIdentifier)
    }

    override func removePassword(for accountIdentifier: String) {
        didDeleteSecretCount += 1
        super.removePassword(for: accountIdentifier)
    }
}

class AuthenticationManagerTest: XCTestCase {

    let urlSessionStub = StubbornNetwork.makeEphemeralSession()
    var network: NetworkClient!
    let keychainMock = TestHelper.keychainMock
    lazy var credentialStore = AccountCredentialStoreMock(keychainProvider: keychainMock)
    var account: Account!

    override func setUp() {
        super.setUp()
        network = NetworkClient(session: urlSessionStub)
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
        urlSessionStub.stub(expectedRequest, data: nil, response: nil, error: nil)
        account.username = "123"
        try keychainMock.add(password: "abc", to: "123")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        authenticationManager.authenticateAccount(account, completion: { (_, _) in
            exp.fulfill()
        })

        wait(for: [exp], timeout: 0.1)
    }

    func testValidAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let data = publicSessionIdentifierResponseBody.data(using: .utf8)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "abc")
        urlSessionStub.stub(try XCTUnwrap(request), data: data, response: nil, error: nil)

        account.username = "123"
        let credentialStore = AccountCredentialStore(keychainProvider: keychainMock)
        try credentialStore.store("abc", of: "123")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        authenticationManager.authenticateAccount(account) { (authenticated, error) in
            XCTAssertTrue(authenticated)
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testInvalidAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let data = publicAccessTokenRequestBody.data(using: .utf8)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "")
        urlSessionStub.stub(try XCTUnwrap(request), data: data, response: nil, error: nil)
        account.username = "123"
        try credentialStore.store("abc", of: "123")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        authenticationManager.authenticateAccount(account) { (authenticated, error) in
            XCTAssertFalse(authenticated)
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testErronousAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let expectedError = NSError(domain: "com.elbedev.test", code: 1)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "")
        urlSessionStub.stub(try XCTUnwrap(request), data: nil, response: nil, error: expectedError)
        account.username = "123"
        let credentialStore = AccountCredentialStore(keychainProvider: keychainMock)
        try credentialStore.store("abc", of: "123")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        authenticationManager.authenticateAccount(account) { (authenticated, error) in
            XCTAssertFalse(authenticated)
            XCTAssertEqual(error, expectedError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testErrorWhenMissingAccountIdentifierAndPassword() {
        let exp = expectation(description: "wait for async")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        account = TestHelper.accountStub()
        authenticationManager.authenticateAccount(account) { (_, error) in
            XCTAssertEqual(error, NSError.missingPasswordError())
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testErrorWhenMissingPassword() {
        let exp = expectation(description: "wait for async")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        account = TestHelper.accountStub()
        account.username = "user id"
        authenticationManager.authenticateAccount(account) { (_, error) in
            XCTAssertEqual(error?.localizedDescription, "Authentication failed")
            XCTAssertEqual(error?.localizedFailureReason, "Please enter your password.")
            XCTAssertNil(error?.localizedRecoverySuggestion)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testStoresPasswordAndSessionTokenForValidAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let data = publicSessionIdentifierResponseBody.data(using: .utf8)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "abc")
        urlSessionStub.stub(try XCTUnwrap(request), data: data, response: nil, error: nil)
        account.username = "123"
        account.password = "abc"
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        authenticationManager.authenticateAccount(account) { (authenticated, error) in
            // Password + session token = 2
            XCTAssertEqual(self.credentialStore.didStoreSecretCount, 2)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testDeletesPasswordForInvalidAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let data = publicAccessTokenRequestBody.data(using: .utf8)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "abc")
        urlSessionStub.stub(try XCTUnwrap(request), data: data, response: nil, error: nil)
        account.username = "123"
        let credentialStore = AccountCredentialStoreMock(keychainProvider: keychainMock)
        try credentialStore.store("abc", of: "123")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        authenticationManager.authenticateAccount(account) { (authenticated, error) in
            XCTAssertEqual(credentialStore.didDeleteSecretCount, 1)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testDoesNotDeletePasswordAndSessionTokenForErronousAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let expectedError = NSError(domain: "com.elbedev.test", code: 1)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "abc")
        urlSessionStub.stub(try XCTUnwrap(request), data: nil, response: nil, error: expectedError)
        account.username = "123"
        let credentialStore = AccountCredentialStore(keychainProvider: keychainMock)
        try credentialStore.store("abc", of: "123")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        authenticationManager.authenticateAccount(account) { (authenticated, error) in
            XCTAssertEqual(self.credentialStore.didDeleteSecretCount, 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
}
