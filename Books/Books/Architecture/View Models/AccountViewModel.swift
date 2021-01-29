//
//  AccountViewModel.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 22.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import Combine
import LibraryCore
import SwiftUI

class AccountViewModel: ObservableObject {

    @Published var account: AccountModel?

    private var disposeBag = Set<AnyCancellable>()

    init() {
        AppEnvironment.current.stores.account.accountPublisher.sink(receiveValue: { [weak self] account in
            self?.account = account
        })
        .store(in: &disposeBag)
    }

}
