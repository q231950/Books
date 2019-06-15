//
//  AuthenticationManager.swift
//  BTLB
//
//  Created by Martin Kim Dung-Pham on 04/10/15.
//  Copyright © 2015 elbedev. All rights reserved.
//

import Foundation
import os

class AuthenticationManager : NSObject {

    let log = OSLog(subsystem: "com.elbedev.books", category: "\(type(of: self))")
    let network: Network
    let keychainManager: KeychainProvider
    let credentialStore: AccountCredentialStore

    @objc required init(network: Network = NetworkClient(), keychainManager: KeychainProvider = KeychainManager()) {
        self.network = network
        self.keychainManager = keychainManager
        self.credentialStore = AccountCredentialStore(keychainProvider: keychainManager)
    }
    
    @objc func authenticateAccount(_ accountIdentifier: String, completion:@escaping (_ authenticated: Bool, _ error: NSError?) -> Void) {
        guard let password = credentialStore.password(for: accountIdentifier) else {
            completion(false, NSError.missingPasswordError())
            return
        }

        self.authenticateHamburgPublicAccount(accountIdentifier:accountIdentifier, password: password, completion: { (authenticated, error) -> Void in
            completion(authenticated, error)
        })
    }

    /**
     Retrieve a session identifier for a belonging account
     - returns: The optional session identifier if one was found
     - parameter accountIdentifier: The identifier of the belonging account
     */
    @objc func sessionIdentifier(for accountIdentifier: String) -> String? {
        let account = "com.elbedev.books.session.account.\(accountIdentifier)"
        return keychainManager.password(for: account)
    }

    /**
     Store a session identifier for an account
     Parameters:
     - parameter identifier: The session identifier to store
     - parameter accountIdentifier: The identifier of the belonging account
     */
    private func store(sessionIdentifier identifier: String, for accountIdentifier: String) throws {
        let account = "com.elbedev.books.session.account.\(accountIdentifier)"
        try keychainManager.add(password:identifier, to:account)
    }
    
    private func authenticateHamburgPublicAccount(accountIdentifier: String, password: String, completion:@escaping (_ authenticated: Bool, _ error: NSError?) -> Void) {
        validate(accountIdentifier, password: password) { (validationStatus) in
            switch validationStatus {
            case .valid:
                completion(true, nil)
            case .invalid:
                completion(false, nil)
            case .error(let err):
                completion(false, err)
            }
        }
    }
    
    private func validate(_ accountIdentifier:String, password:String, completion:@escaping ((_ status:ValidationStatus) -> Void)) {
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

    private func parseSessionIdentifier(data: Data?, accountIdentifier: String, completion: @escaping ((_ status: ValidationStatus) -> Void)) {
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
