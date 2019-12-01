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
    var loansViewModel: LoansViewModel? {
        didSet {
//            DispatchQueue.main.async {
                self.didChange.send(self)
//            }
        }
    }
    var accountViewModel: AccountViewModel

    @Published var authenticated: Bool = false {
        didSet {
            self.handleAuthenticationUpdate(account: self.accountViewModel.account)
        }
    }
    private let authenticationManager: AuthenticationManager

    init(authenticationManager: AuthenticationManager = AuthenticationManager.shared, accountViewModel: AccountViewModel) {
        self.authenticationManager = authenticationManager
        self.accountViewModel = accountViewModel
        if let password = authenticationManager.password(for: accountViewModel.account.username) {
            accountViewModel.account = Account(username: accountViewModel.account.username, password: password)
        }

        authenticationSink = authenticationManager.authenticatedSubject
            .sink(receiveCompletion: { (error) in
                print(error)
            }) { (authenticated) in
                print("authenticated: \(authenticated)")
                self.authenticated = authenticated
        }
    }

    func authenticate() {
        authenticationManager.authenticateAccount(accountViewModel.account)
    }

    func signOut() {
        let accountIdentifier = accountViewModel.account.username
        accountViewModel.account = Account()
        authenticationManager.signOut(accountIdentifier)
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

