//
//  Authentication.swift
//  
//
//  Created by Martin Kim Dung-Pham on 15.06.19.
//

import SwiftUI
import Combine
import LibraryCore

public class AuthenticationViewModel: BindableObject {

    public var didChange = PassthroughSubject<AuthenticationViewModel, Never>()

    public var authenticated: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }

    public init() {}

    func authenticate(account: AccountViewModel) {
        let authenticationManager = AuthenticationManager.shared
        authenticationManager.authenticateAccount(account.account) { (valid, error) in
            self.authenticated = valid
        }
    }
}

