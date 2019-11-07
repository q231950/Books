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

public enum AuthenticationError: Error, Equatable {
    public static func == (lhs: AuthenticationError, rhs: AuthenticationError) -> Bool {
        switch (lhs, rhs) {
        case (.subsystem(let lhsErr), .subsystem(let rhsErr)):
            return lhsErr.localizedDescription == rhsErr.localizedDescription
        case (.invalid, .invalid):
            return true
        case (.missingPassword, .missingPassword):
            return true
        default:
            return false
        }
    }

    case subsystem(Error)
    case invalid
    case missingPassword
}

public class AuthenticationManager {

    public

    static var shared = AuthenticationManager()

    public let authenticatedSubject = PassthroughSubject<Bool, AuthenticationError>()

    public func authenticateAccount(_ account: Account) {
        let password = (account.password != "") ? account.password : nil
        authenticateAccount(account.username, password: password, completion: { [weak self] (authenticated, error) in
            if let error = error {
                self?.authenticatedSubject.send(completion: .failure(error))
            } else {
                self?.authenticatedSubject.send(authenticated)
            }
        })
    }

    private

    let log = OSLog(subsystem: "com.elbedev.books", category: "\(AuthenticationManager.self)")
    let network: NetworkClient
    let credentialStore: AccountCredentialStore

    init(network: NetworkClient = NetworkClient.shared, credentialStore: AccountCredentialStore = AccountCredentialStore(keychainProvider: KeychainManager())) {
        self.network = network
        self.credentialStore = credentialStore
    }

    private func authenticateAccount(_ accountIdentifier: String, password: String? = nil, completion:@escaping (_ authenticated: Bool, _ error: AuthenticationError?) -> Void) {

        guard let password = password ?? credentialStore.password(for: accountIdentifier) else {
            completion(false, .missingPassword)
            return
        }

        self.authenticateHamburgPublicAccount(accountIdentifier:accountIdentifier, password: password, completion: { (authenticated, error) -> Void in
            guard error == nil else {
                completion(authenticated, error)
                return
            }

            do {
                if authenticated {
                    try self.credentialStore.store(password, of: accountIdentifier)
                } else {
                    self.credentialStore.removePassword(for: accountIdentifier)
                }
            } catch (_) {}
            completion(authenticated, error)

        })
    }

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
    private func store(sessionIdentifier identifier: String, for accountIdentifier: String) throws {
        let account = "com.elbedev.books.session.account.\(accountIdentifier)"
        try credentialStore.store(identifier, of: account)
    }
    
    private func authenticateHamburgPublicAccount(accountIdentifier: String, password: String, completion:@escaping (_ authenticated: Bool, _ error: AuthenticationError?) -> Void) {
        validate(accountIdentifier, password: password) { (validationStatus) in
            switch validationStatus {
            case .valid:
                completion(true, nil)
            case .invalid:
                completion(false, nil)
            case .error(let err):
                completion(false, .subsystem(err))
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

        let task = network.dataTask(with: request, completionHandler: {(data, response, error) -> Void in

            if let error = error {
                os_log("Failed to get access token", log: self.log, type: .debug, error.localizedDescription as CVarArg)
                completion(.error(error as NSError))
                return
            }

            self.parseSessionIdentifier(data:data, accountIdentifier: accountIdentifier, completion: completion)
        })

        task.resume()
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
