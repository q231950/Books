//
//  AuthenticationManagerStub.swift
//  LibraryCoreTests
//
//  Created by Martin Kim Dung-Pham on 26.12.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

#if DEBUG

import Foundation

/// An Authentication Manager stub
public class AuthenticationManagerStub: AuthenticationManager {
    public var authenticated: Bool = false
    public var error: NSError? = nil
    public var stubbedSessionIdentifier: String? = nil

    public override func authenticateAccount(_ account: Account, completion: @escaping (Bool, NSError?) -> Void) {
        completion(authenticated, error)
    }

    override func sessionIdentifier(for accountIdentifier: String) -> String? {
        return stubbedSessionIdentifier
    }
}

#endif
