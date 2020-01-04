//
//  LoansViewModel.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 13.07.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import Combine
import SwiftUI
import LibraryCore

class LoansViewModel: ObservableObject {
    var didChange = PassthroughSubject<[LoanViewModel], Never>()

    @Published var loans: [LoanViewModel] = []

    init(account: Account, authenticationManager: AuthenticationManager) {
        let scraper = PublicLibraryScraper.default
        scraper.loans(account, authenticationManager: authenticationManager, completion: { (error, loans) -> (Void) in

            let loanViewModels = loans.map { LoanViewModel(loan: $0) }

            DispatchQueue.main.async {
                self.loans = loanViewModels
            }
        })
    }
}
