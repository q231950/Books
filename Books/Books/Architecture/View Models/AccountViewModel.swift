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

class AccountViewModel: ObservableObject, CredentialsProvider {

    var account = CurrentValueSubject<AccountModel, Never>(AccountModel(credentials: Credentials()))

    var credentialsPublisher = PassthroughSubject<Credentials, Never>()

    private var disposeBag = Set<AnyCancellable>()

    init() {
        account.sink(receiveValue: { [weak self] account in
            self?.credentialsPublisher.send(account.credentials)
        })
        .store(in: &disposeBag)
    }

}
