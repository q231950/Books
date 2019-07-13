//
//  Authentication.swift
//  
//
//  Created by Martin Kim Dung-Pham on 15.06.19.
//

import SwiftUI
import Combine
import LibraryCore

class AuthenticationViewModel: BindableObject {

    var didChange = PassthroughSubject<AuthenticationViewModel, Never>()
    public var loansViewModel: LoansViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    var account: Account?

    public var authenticated: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }

            self.handleAuthenticationUpdate(account: self.account)
        }
    }
    private let authenticationManager: AuthenticationManager

    init(authenticationManager: AuthenticationManager = AuthenticationManager.shared) {
        self.authenticationManager = authenticationManager
    }

    func authenticate(account: AccountViewModel) {
        self.account = account.account // account already available at init?
        authenticationManager.authenticateAccount(account.account) { (valid, error) in
            guard error == nil else {
                return
            }
            self.authenticated = valid
        }
    }

    private func handleAuthenticationUpdate(account: Account?) {
        guard let account = account else {
            return
        }

        if self.authenticated {
            self.loansViewModel = LoansViewModel(account: account, authenticationManager: authenticationManager)
        }
    }
}

