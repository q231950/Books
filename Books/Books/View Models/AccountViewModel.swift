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

    public var willChange = PassthroughSubject<AccountViewModel, Never>()
    public var didChange = PassthroughSubject<AccountViewModel, Never>()

    public var account: Account {
        willSet {
            DispatchQueue.main.async {
                self.willChange.send(self)
            }
        }
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }

    init(account: Account) {
        self.account = account
        let _ = account.didChange.sink { (updatedAccount) in
            self.account = updatedAccount
        }
    }
}
