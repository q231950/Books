//
//  BorrowedItemsViewModel.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 13.07.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import Combine
import SwiftUI
import LibraryCore

class BorrowedItemsViewModel: ObservableObject {
    @Published var borrowedItems: [FlamingoLoan]
    private var disposeBag = [AnyCancellable]()

    init() {
        borrowedItems = AppEnvironment.current.stores.borrowedItems.items.value

        AppEnvironment.current.stores.borrowedItems.items.sink { items in
            self.borrowedItems = items
        }
        .store(in: &disposeBag)
    }
}
