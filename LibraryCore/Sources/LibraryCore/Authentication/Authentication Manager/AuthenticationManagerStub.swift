//
//  AuthenticationManagerMock.swift
//  LibraryCoreTests
//
//  Created by Martin Kim Dung-Pham on 26.12.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

#if DEBUG

import Foundation

/// An Authentication Manager stub
public class AuthenticationManagerStub: AuthenticationManager {
    public var authenticated: AuthenticationState = .authenticating
    public var error: NSError? = nil
    public var stubbedSessionIdentifier: String? = nil

    public override func authenticateAccount(username: String?, password: String?) {
        authenticatedSubject.send(authenticated)
    }

    override func sessionIdentifier(for accountIdentifier: String) -> String? {
        return stubbedSessionIdentifier
    }
}

#endif
