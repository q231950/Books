//
//  AuthenticationValidationStatus.swift
//  books
//
//  Created by Martin Kim Dung-Pham on 01/09/14.
//  Copyright (c) 2014 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation

enum AuthenticationValidationStatus: Equatable {
    static func == (lhs: AuthenticationValidationStatus, rhs: AuthenticationValidationStatus) -> Bool {
        switch (lhs, rhs) {
        case (.error(let lhsErr), .error(let rhsErr)):
            return lhsErr.localizedDescription == rhsErr.localizedDescription
        case (.valid, .valid):
            return true
        case (.invalid, .invalid):
            return true
        default:
            return false
        }
    }

    case valid
    case invalid
    case error(Error)
}
