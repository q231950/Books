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
    private let authenticationManager: AuthenticationManager

    public init(authenticationManager: AuthenticationManager = AuthenticationManager.shared) {
        self.authenticationManager = authenticationManager
    }

    func authenticate(account: AccountViewModel) {
        authenticationManager.authenticateAccount(account.account) { (valid, error) in
            guard error == nil else {
                return
            }
            self.authenticated = valid
        }
    }
}

