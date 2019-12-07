//
//  AuthenticationManagerTest.swift
//  LibraryCoreTests
//
//  Created by Martin Kim Dung-Pham on 08.09.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import XCTest
import StubbornNetwork
import Combine
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
    var sink: AnyCancellable?

    override func setUp() {
        super.setUp()
        network = NetworkClient(session: urlSessionStub)
        account = TestHelper.accountStub()
    }

    func testAuthenticationRequest() {
        let exp = expectation(description: "wait for async")
        var expectedRequest = URLRequest(url: URL(string: "https://zones.buecherhallen.de/app_webuser/WebUserSvc.asmx")!)
        expectedRequest.httpMethod = "POST"
        expectedRequest.allHTTPHeaderFields = ["Content-Type":"text/xml; charset=utf-8",
                                               "SOAPAction":"http://bibliomondo.com/websevices/webuser/CheckBorrower",
                                               "Accept":"*/*",
                                               "Accept-Language":"en-us",
                                               "Accept-Encoding":"br, gzip, deflate"]
        let data = publicSessionIdentifierResponseBody.data(using: .utf8)
        urlSessionStub.stub(expectedRequest, data: data, response: HTTPURLResponse(), error: nil)
        account.username = "123"
        account.password = "abc"
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        sink = authenticationManager.authenticatedSubject.sink(receiveCompletion: { (_) in
            
        }) { _ in
            exp.fulfill()
        }

        authenticationManager.authenticateAccount(username: account.username, password: account.password)
        wait(for: [exp], timeout: 0)
    }

    func testValidAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let data = publicSessionIdentifierResponseBody.data(using: .utf8)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "abc")
        urlSessionStub.stub(try XCTUnwrap(request), data: data, response: nil, error: nil)

        account.username = "123"
        account.password = "abc"
        let credentialStore = AccountCredentialStore(keychainProvider: keychainMock)
        try credentialStore.store("abc", of: "123")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        sink = authenticationManager.authenticatedSubject.sink(receiveCompletion: { _ in
            XCTFail()
        }) {
            if case AuthenticationState.authenticationComplete(.authenticated) = $0 { exp.fulfill() }
        }
        authenticationManager.authenticateAccount(username: account.username, password: account.password)
        wait(for: [exp], timeout: 0)
    }

    func testInvalidAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let data = publicAccessTokenRequestBody.data(using: .utf8)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "")
        urlSessionStub.stub(try XCTUnwrap(request), data: data, response: nil, error: nil)
        account.username = "123"
        account.password = "abc"
        try credentialStore.store("abc", of: "123")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        sink = authenticationManager.authenticatedSubject.sink(receiveCompletion: { _ in
            XCTFail()
        }) {
            if case AuthenticationState.authenticationComplete(.manualAuthenticationFailed) = $0 { exp.fulfill() }
        }
        authenticationManager.authenticateAccount(username: account.username, password: account.password)
        wait(for: [exp], timeout: 0)
    }

    enum TestingError: Error {
        case loadingError
    }
    func testErronousAuthentication() throws {

        let exp = expectation(description: "wait for async")
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "")
        urlSessionStub.stub(try XCTUnwrap(request), data: nil, response: nil, error: TestingError.loadingError)
        account.username = "123"
        account.password = "abc"
        let credentialStore = AccountCredentialStore(keychainProvider: keychainMock)
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        sink = authenticationManager.authenticatedSubject.sink(receiveCompletion: { _ in
        }) { value in
            switch value {
            case .authenticationError(let error):
                if case AuthenticationError.subsystem(_) = error { exp.fulfill() }
            default:
                XCTFail()
            }
        }
        authenticationManager.authenticateAccount(username: account.username, password: account.password)
        wait(for: [exp], timeout: 0)
    }

    func testErrorWhenMissingPassword() {
        let exp = expectation(description: "wait for async")
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        account = TestHelper.accountStub()
        account.username = "user id"
        sink = authenticationManager.authenticatedSubject.sink(receiveCompletion: { _ in
        }) { value in
            switch value {
            case .authenticationComplete(.missingPassword):
                exp.fulfill()
            default:
                XCTFail()
            }
        }
        authenticationManager.authenticateAccount(username: account.username, password: account.password)
        wait(for: [exp], timeout: 0)
    }

    func testStoresPasswordAndSessionTokenForValidAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let data = publicSessionIdentifierResponseBody.data(using: .utf8)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "abc")
        urlSessionStub.stub(try XCTUnwrap(request), data: data, response: nil, error: nil)
        account.username = "123"
        account.password = "abc"
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        sink = authenticationManager.authenticatedSubject.sink(receiveCompletion: { completion in
        }) { _ in
            // Password + session token = 2
            XCTAssertEqual(self.credentialStore.didStoreSecretCount, 2)
            exp.fulfill()
        }

        authenticationManager.authenticateAccount(username: account.username, password: account.password)
        wait(for: [exp], timeout: 0)
    }

    func testDeletesPasswordForInvalidAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let data = publicAccessTokenRequestBody.data(using: .utf8)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "abc")
        urlSessionStub.stub(try XCTUnwrap(request), data: data, response: nil, error: nil)
        account.username = "123"
        account.password = "abc"
        let credentialStore = AccountCredentialStoreMock(keychainProvider: keychainMock)
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        sink = authenticationManager.authenticatedSubject.sink(receiveCompletion: { completion in
        }) { _ in
            XCTAssertEqual(credentialStore.didDeleteSecretCount, 1)
            exp.fulfill()
        }
        authenticationManager.authenticateAccount(username: account.username, password: account.password)
        wait(for: [exp], timeout: 0)
    }

    func testDoesNotDeletePasswordAndSessionTokenForErronousAuthentication() throws {
        let exp = expectation(description: "wait for async")
        let expectedError = NSError(domain: "com.elbedev.test", code: 1)
        let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: "123", password: "abc")
        urlSessionStub.stub(try XCTUnwrap(request), data: nil, response: nil, error: expectedError)
        account.username = "123"
        account.password = "abc"
        let credentialStore = AccountCredentialStore(keychainProvider: keychainMock)
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        sink = authenticationManager.authenticatedSubject.sink(receiveCompletion: { completion in
        }) { _ in
            XCTAssertEqual(self.credentialStore.didDeleteSecretCount, 0)
            exp.fulfill()
        }
        authenticationManager.authenticateAccount(username: account.username, password: account.password)
        wait(for: [exp], timeout: 0)
    }

    func testSignOutDeletesPasswordAndSessionToken() throws {
        let credentialStore = AccountCredentialStore(keychainProvider: keychainMock)
        let authenticationManager = AuthenticationManager(network: network, credentialStore: credentialStore)
        try authenticationManager.store(password: "abc", for: "123")
        try authenticationManager.store(sessionIdentifier: "session-identifier", for: "123")
        account.username = "123"
        account.password = "abc"
        authenticationManager.signOut(account.username)

        // then both, password and session identifier must deleted from the keychain
        XCTAssertEqual(keychainMock.addedKeychainItems.count, 0)
    }
}
