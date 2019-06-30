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

class AccountViewModel: BindableObject {
    public var account: Account {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }

    public var didChange: PassthroughSubject<AccountViewModel, Never>

    init(account: Account) {
        didChange = PassthroughSubject<AccountViewModel, Never>()
        self.account = account
        let _ = account.didChange.sink { (updatedAccount) in
            self.account = updatedAccount
        }
    }
}
