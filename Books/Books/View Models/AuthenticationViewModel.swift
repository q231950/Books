//
//  Authentication.swift
//  
//
//  Created by Martin Kim Dung-Pham on 15.06.19.
//

import SwiftUI
import Combine
import LibraryCore

class AuthenticationViewModel: ObservableObject {

    var didChange = PassthroughSubject<AuthenticationViewModel, Never>()
    var authenticationSink: AnyCancellable?
    @Published var loansViewModel: LoansViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    var accountViewModel: AccountViewModel

    public var authenticated: Bool = false {
        didSet {
            self.didChange.send(self)

            self.handleAuthenticationUpdate(account: self.accountViewModel.account)
        }
    }
    private let authenticationManager: AuthenticationManager

    init(authenticationManager: AuthenticationManager = AuthenticationManager.shared, accountViewModel: AccountViewModel) {
        self.authenticationManager = authenticationManager
        self.accountViewModel = accountViewModel
    }

    func authenticate() {
        authenticationSink = authenticationManager.authenticatedSubject
            .sink(receiveCompletion: { (error) in
                print(error)
            }) { (authenticated) in
                print("\(authenticated)")
                self.authenticated = authenticated
        }
        authenticationManager.authenticateAccount(accountViewModel.account)
    }

    func signOut() {
        print("sign out")
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

