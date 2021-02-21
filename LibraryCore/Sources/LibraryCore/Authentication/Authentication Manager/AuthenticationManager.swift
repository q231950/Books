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

public enum AuthenticationError: Error {
    case subsystem(Error)
}

public typealias AuthenticationStateSubject = CurrentValueSubject<AuthenticationState, Never>

public class AuthenticationManager {

    public let authenticationSubject: AuthenticationStateSubject?
    private let log = OSLog(subsystem: .authenticationManager, category: .development)
    private let network: NetworkClient
    private let credentialStore: AccountCredentialStore

    public convenience init(authenticationSubject: AuthenticationStateSubject? = nil) {
        self.init(network: NetworkClient.shared,
                  credentialStore: AccountCredentialStore(keychainProvider: KeychainManager()),
                  authenticationSubject: authenticationSubject)
    }

    init(network: NetworkClient = NetworkClient.shared,
         credentialStore: AccountCredentialStore = AccountCredentialStore(keychainProvider: KeychainManager()),
         authenticationSubject: AuthenticationStateSubject? = nil) {
        self.network = network
        self.credentialStore = credentialStore
        self.authenticationSubject = authenticationSubject
    }

    public func authenticateAccount(username: String?, password: String?) {
        os_log(.info, log: log, "Initiating authentication for `%{private}@`", username ?? "nil")

        guard let username = username, username != "" else {
            os_log(.error, log: log, "Authentication failed, no username given")
            authenticationSubject?.send(.authenticationComplete(.missingUsername))
            return
        }

        guard let password = password, password != "" else {
            os_log(.error, log: log, "Authentication failed, no password given")
            authenticationSubject?.send(.authenticationComplete(.missingPassword))
            return
        }

        authenticateAccount(username, password: password, completion: { [weak self] authenticated in
            guard let self = self else { return }
            if case let .authenticationError(error)  = authenticated {
                self.authenticationSubject?.send(.authenticationError(error))
            } else {
                os_log(.info, log: self.log, "Finished authentication for account %{private}@", username)

                self.authenticationSubject?.send(authenticated)
            }
        })
    }

    public func signOut(_ accountIdentifier: String) {
        os_log(.info, log: log, "Signing out `%{private}@`", accountIdentifier)

        removePassword(for: accountIdentifier)
        removeSessionIdentifier(for: accountIdentifier)
        authenticationSubject?.send(.authenticationComplete(.signOutSucceeded))
    }

    //MARK: - Account Authentication

    private func authenticateAccount(_ identifier: String, password: String, completion:@escaping (_ authenticated: AuthenticationState) -> Void) {
        validate(identifier, password: password) { (validationStatus) in
            do {
                switch validationStatus {
                case .valid:
                    try self.store(password: password, for: identifier)
                    let credentials = Credentials().withUsername(identifier).withPassword(password)
                    completion(.authenticationComplete(.authenticated(credentials: credentials)))
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
            os_log(.info, log: log, "Failed to create access token request `%{public}@`", err)
            completion(.error(err))
            return
        }

        network.dataTask(with: request, completionHandler: {(data, response, error) -> Void in

            if let error = error {
                os_log(.info, log: self.log, "Failed to get access token `%{public}@`", error.localizedDescription)
                completion(.error(error as NSError))
                return
            }

            self.parseSessionIdentifier(data:data, accountIdentifier: accountIdentifier, completion: completion)
        }).resume()
    }


    //MARK: - Password

    func store(password: String, for accountIdentifier: String) throws {
        os_log("Storing password for account %{public}@", log: log, type: .info, accountIdentifier)

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
        os_log("Removing password for account %{public}@", log: log, type: .info, accountIdentifier)

        let account = "com.elbedev.books.account.password.\(accountIdentifier)"
        self.credentialStore.removePassword(for: account)
    }


    //MARK: - Session Identifier

    /**
     Retrieve a session identifier for a belonging account
     - returns: The optional session identifier if one was found
     - parameter accountIdentifier: The identifier of the belonging account
     */
    public func sessionIdentifier(for accountIdentifier: String) -> String? {
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
        os_log("Parsing access token from authentication response", log: log, type: .info)

        let sessionIdentifierParser = SessionIdentifierParser()
        let parseResult = sessionIdentifierParser.parseSessionIdentifier(data: data)
        switch parseResult {
        case .success(let token):
            do {
                os_log(.info, log: log, "Storing access token %{private}@", token)
                try store(sessionIdentifier: token, for: accountIdentifier)
                completion(.valid)
            } catch let err {
                completion(.error(err as NSError))
            }
        case .failure:
            os_log(.info, log: log, "Failed to get access token because of invalid credentials")
            completion(.invalid)
        case .error(let err):
            os_log(.info, log: log, "Failed to get access token %{public}@", err.localizedDescription)
            completion(.error(err as NSError))
        }
    }
}
