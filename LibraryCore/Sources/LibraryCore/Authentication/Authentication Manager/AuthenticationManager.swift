//
//  AuthenticationManager.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 04/10/15.
//  Copyright © 2015 elbedev. All rights reserved.
//

import Foundation
import os
import Combine

public enum AuthenticationState {
    public enum Completion {
        case authenticated
        case manualAuthenticationFailed
        case automaticAuthenticationFailed
        case missingUsername
        case missingPassword
        case signOutSucceeded
    }

    case authenticating
    case authenticationComplete(Completion)
    case authenticationError(Error)

}

public enum AuthenticationError: Error {
    case subsystem(Error)
}

public class AuthenticationManager {

    typealias Keys = UserDefaults.Keys

    public static var shared = AuthenticationManager()

    public let authenticatedSubject = PassthroughSubject<AuthenticationState, AuthenticationError>()

    public func authenticateAccount(username: String?, password: String?) {
        guard let username = username, username != "" else {
            authenticatedSubject.send(.authenticationComplete(.missingUsername))
            return
        }

        guard let password = password, password != "" else {
            authenticatedSubject.send(.authenticationComplete(.missingPassword))
            return
        }

        authenticateAccount(username, password: password, completion: { [weak self] authenticated in
            if case let .authenticationError(error)  = authenticated {
                self?.authenticatedSubject.send(.authenticationError(error))
            } else {
                UserDefaults.standard.setValue(username, forKey: Keys.defaultAccountIdentifier)
                self?.authenticatedSubject.send(authenticated)
            }
        })
    }

    public func signOut(_ accountIdentifier: String) {
        UserDefaults.standard.removeObject(forKey: Keys.defaultAccountIdentifier)
        removePassword(for: accountIdentifier)
        removeSessionIdentifier(for: accountIdentifier)
        authenticatedSubject.send(.authenticationComplete(.signOutSucceeded))
    }

    private let log = OSLog(subsystem: "com.elbedev.books", category: "\(AuthenticationManager.self)")
    private let network: NetworkClient
    private let credentialStore: AccountCredentialStore

    init(network: NetworkClient = NetworkClient.shared, credentialStore: AccountCredentialStore = AccountCredentialStore(keychainProvider: KeychainManager())) {
        self.network = network
        self.credentialStore = credentialStore
    }


    //MARK: - Account Authentication

    private func authenticateAccount(_ identifier: String, password: String, completion:@escaping (_ authenticated: AuthenticationState) -> Void) {
        validate(identifier, password: password) { (validationStatus) in
            do {
                switch validationStatus {
                case .valid:
                    try self.store(password: password, for: identifier)
                    completion(.authenticationComplete(.authenticated))
                case .invalid:
                    self.credentialStore.removePassword(for: identifier)
                    completion(.authenticationComplete(.manualAuthenticationFailed))
                case .error(let err):
                    completion(.authenticationError(AuthenticationError.subsystem(err)))
                }
            } catch {
                completion(.authenticationError(AuthenticationError.subsystem(error)))
            }
        }
    }

    private func validate(_ accountIdentifier:String, password:String, completion:@escaping ((_ status:AuthenticationValidationStatus) -> Void)) {
        guard let request = RequestBuilder.default.sessionIdentifierRequest(accountIdentifier: accountIdentifier, password: password) else {
            let err = NSError(domain: "\(type(of: self)).validate", code: 1)
            os_log("Failed to create access token request", log: self.log, type: .debug, err as CVarArg)
            completion(.error(err))
            return
        }

        network.dataTask(with: request, completionHandler: {(data, response, error) -> Void in

            if let error = error {
                os_log("Failed to get access token", log: self.log, type: .debug, error.localizedDescription as CVarArg)
                completion(.error(error as NSError))
                return
            }

            self.parseSessionIdentifier(data:data, accountIdentifier: accountIdentifier, completion: completion)
        }).resume()
    }


    //MARK: - Password

    func store(password: String, for accountIdentifier: String) throws {
        let account = "com.elbedev.books.account.password.\(accountIdentifier)"
        try self.credentialStore.store(password, of: account)
    }

    public func password(for accountIdentifier: String) -> String? {
        let account = "com.elbedev.books.account.password.\(accountIdentifier)"
        return credentialStore.password(for: account)
    }

    /// Deletes the password of the given account from the keychain
    /// - parameter accountIdentifier: The identifier of the belonging account
    func removePassword(for accountIdentifier: String) {
        let account = "com.elbedev.books.account.password.\(accountIdentifier)"
        self.credentialStore.removePassword(for: account)
    }


    //MARK: - Session Identifier

    /**
     Retrieve a session identifier for a belonging account
     - returns: The optional session identifier if one was found
     - parameter accountIdentifier: The identifier of the belonging account
     */
    func sessionIdentifier(for accountIdentifier: String) -> String? {
        let account = "com.elbedev.books.session.account.\(accountIdentifier)"
        return credentialStore.password(for: account)
    }

    /**
     Store a session identifier for an account
     Parameters:
     - parameter identifier: The session identifier to store
     - parameter accountIdentifier: The identifier of the belonging account
     */
    func store(sessionIdentifier identifier: String, for accountIdentifier: String) throws {
        let account = "com.elbedev.books.session.account.\(accountIdentifier)"
        try credentialStore.store(identifier, of: account)
    }

    /// Deletes the session identifier of the given account from the keychain
    /// - parameter accountIdentifier: The identifier of the belonging account
    func removeSessionIdentifier(for accountIdentifier: String) {
        let account = "com.elbedev.books.session.account.\(accountIdentifier)"
        credentialStore.removePassword(for: account)
    }

    private func parseSessionIdentifier(data: Data?, accountIdentifier: String, completion: @escaping ((_ status: AuthenticationValidationStatus) -> Void)) {
        let sessionIdentifierParser = SessionIdentifierParser()
        let parseResult = sessionIdentifierParser.parseSessionIdentifier(data: data)
        switch parseResult {
        case .success(let token):
            do {
                os_log("Storing access token", log: self.log, type: .debug, [token] as CVarArg)
                try store(sessionIdentifier: token, for: accountIdentifier)
                completion(.valid)
            } catch let err {
                completion(.error(err as NSError))
            }
        case .failure:
            completion(.invalid)
        case .error(let err):
            os_log("Failed to get access token", log: self.log, type: .debug, err.localizedDescription as CVarArg)
            completion(.error(err as NSError))
        }
    }
}
