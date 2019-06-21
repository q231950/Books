//
//  Authentication.swift
//  
//
//  Created by Martin Kim Dung-Pham on 15.06.19.
//

import SwiftUI
import Combine

public class Authentication: BindableObject {

    private let authenticationManager = AuthenticationManager()

    public var didChange = PassthroughSubject<Authentication, Never>()

    public var authenticated: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }

    public init() {}

    public func authenticate(account: Account) {
        authenticationManager.authenticateAccount(account) { (valid, error) in
                self.authenticated = valid
        }
    }
}

