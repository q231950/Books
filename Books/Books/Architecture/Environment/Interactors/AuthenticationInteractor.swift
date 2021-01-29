//
//  AuthenticationInteractor.swift
//  Books
//
//  Created by Kim Dung-Pham on 16.01.21.
//  Copyright © 2021 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation
import LibraryCore
import Combine

struct AuthenticationInteractor {

    private var authenticationManager: AuthenticationManager
    private var disposeBag = Set<AnyCancellable>()

    init(authenticationManager: AuthenticationManager) {
        self.authenticationManager = authenticationManager
    }

    func attemptAutomaticAuthentication() {
        AppEnvironment.current.authenticationStatePublisher.send(.authenticating)

        if let username = AppEnvironment.current.stores.account.signedInAccountIdentifier(),
           let password = authenticationManager.password(for: username) {
            let credentials = Credentials().withUsername(username).withPassword(password)
            if credentials.isValid {
                authenticate(credentials: credentials)
                return
            }
        }

        AppEnvironment.current.authenticationStatePublisher.send(.authenticationComplete(.automaticAuthenticationFailed))
    }

    func authenticate(credentials: Credentials) {
        AppEnvironment.current.authenticationStatePublisher.send(.authenticating)

        authenticationManager.authenticateAccount(username: credentials.username,
                                                  password: credentials.password)
    }

    func signOut() {
        let accountPublisher = AppEnvironment.current.stores.account.accountPublisher
        let currentAccount = accountPublisher.value

        guard let username = currentAccount?.credentials.username else { return }

        authenticationManager.signOut(username)
        AppEnvironment.current.stores.account.removeSignedInAccountIdentifier(username)
        accountPublisher.send(nil)

    }
}
