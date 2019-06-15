//
//  AuthenticationManagerMock.swift
//  BTLBTests
//
//  Created by Martin Kim Dung-Pham on 26.12.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation
@testable import LibraryCore

class AuthenticationManagerMock: AuthenticationManager {
    var authenticated: Bool = false
    var error: NSError? = nil

    override func authenticateAccount(_ accountIdentifier: String, completion: @escaping (Bool, NSError?) -> Void) {
        completion(authenticated, error)
    }
}
