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

struct AppEnvironment {

    static var current: AppEnvironment = AppEnvironment()

    // MARK: - Publishers

    let appStatePublisher = AppStatePublisher(.authentication)
    let authenticationStatePublisher = AuthenticationStateSubject(.idle)

    // MARK: - Interactors

    let authenticationInteractor: AuthenticationInteractor
    let borrowedItemInteractor: BorrowedItemInteractor

    // MARK: - Stores
    let stores: Stores

    private init() {

        let authenticationManager = AuthenticationManager(authenticationSubject: authenticationStatePublisher)
        let accountStore = AccountStore(authenticationManager: authenticationManager)

        stores = Stores(account: accountStore,
                                borrowedItems: BorrowedItemsStore(authenticationStatePublisher: authenticationStatePublisher, authenticationManager: authenticationManager))

        authenticationInteractor = AuthenticationInteractor(authenticationManager: authenticationManager)
        borrowedItemInteractor = BorrowedItemInteractor(authenticationStatePublisher: authenticationStatePublisher, accountStore: accountStore)
    }
}

struct Stores {

    let account: AccountStore
    let borrowedItems: BorrowedItemsStore
}
