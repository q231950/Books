//
//  Environment.swift
//  Books
//
//  Created by Kim Dung-Pham on 16.01.21.
//  Copyright © 2021 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation
import Combine
import LibraryCore

typealias AppStatePublisher = CurrentValueSubject<AppState, Never>
typealias AuthenticationStatePublisher = CurrentValueSubject<AuthenticationState, Never>

struct AppEnvironment {

    static var current: AppEnvironment = {
        AppEnvironment()
    }()

    let appStatePublisher = AppStatePublisher(.authentication)
    let authenticationStatePublisher = AuthenticationStatePublisher(.idle)

    let authenticationInteractor: AuthenticationInteractor

    let stores: Stores

    private init() {

        stores = Stores.current

        let authenticationManager = AuthenticationManager(accountStore: self.stores.account)
        authenticationInteractor = AuthenticationInteractor(authenticationManager: authenticationManager)
    }
}

struct Stores {
    static let current = Stores(account: AccountStore())

    let account: AccountStore
}
