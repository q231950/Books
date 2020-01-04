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
    public var account: AccountModel {
        didSet {
            self.didChange.send(self)
        }
    }

    public var didChange: PassthroughSubject<AccountViewModel, Never>

    init(account: AccountModel) {
        didChange = PassthroughSubject<AccountViewModel, Never>()
        self.account = account
    }
}
