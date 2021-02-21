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
            self.didChange.send(self)
        }
    }
    var accountViewModel: AccountViewModel

    @Published var state: AuthenticationState = .authenticating {
        didSet {
            self.handleAuthenticationUpdate(account: self.accountViewModel.account)
        }
    }
    private let authenticationManager: AuthenticationManager

    init(authenticationManager: AuthenticationManager, accountViewModel: AccountViewModel) {
        self.authenticationManager = authenticationManager
        self.accountViewModel = accountViewModel
        if let password = authenticationManager.password(for: accountViewModel.account.username) {
            accountViewModel.account = AccountModel(username: accountViewModel.account.username, password: password)
        }

        authenticationSink = authenticationManager.authenticatedSubject
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let authenticationError):
                    self.state = .authenticationError(authenticationError)
                case .finished: ()
                }
            }) { authenticated in
                self.state = authenticated
        }
    }

    func attemptAutomaticAuthentication() {
        if accountViewModel.account.username != "" && self.accountViewModel.account.password != "" {
            self.authenticationManager.authenticateAccount(username: self.accountViewModel.account.username,
                                                           password: self.accountViewModel.account.password)
        } else {
            authenticationManager.authenticatedSubject.send(.authenticationComplete(.automaticAuthenticationFailed))
        }
    }

    func authenticate() {
        authenticationManager.authenticateAccount(username: accountViewModel.account.username,
                                                  password: accountViewModel.account.password)
    }

    func signOut() {
        let accountIdentifier = accountViewModel.account.username
        accountViewModel.account = AccountModel()
        authenticationManager.signOut(accountIdentifier)
    }

    private func handleAuthenticationUpdate(account: AccountModel?) {
        guard let account = account else {
            return
        }

        if case AuthenticationState.authenticationComplete(.authenticated) = self.state {
            self.loansViewModel = LoansViewModel(account: account, authenticationManager: authenticationManager)
        }
    }
}

