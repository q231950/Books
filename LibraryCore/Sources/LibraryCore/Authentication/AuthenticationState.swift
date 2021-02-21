//
//  AuthenticationState.swift
//  Books
//
//  Created by Kim Dung-Pham on 16.01.21.
//  Copyright © 2021 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation

public enum AuthenticationState {
    public enum Completion {
        case authenticated(credentials: Credentials)
        case manualAuthenticationFailed
        case automaticAuthenticationFailed
        case missingUsername
        case missingPassword
        case signOutSucceeded
    }

    case idle
    case authenticating
    case authenticationComplete(Completion)
    case authenticationError(Error)

}
