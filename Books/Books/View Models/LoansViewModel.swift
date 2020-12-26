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
    @Published var loans: [LoanViewModel] = []

    init(account: AccountModel, authenticationManager: AuthenticationManager) {
        let apiClient = APIClient.shared
        apiClient.loans(account, authenticationManager: authenticationManager, completion: { (error, loans) -> (Void) in

            let loanViewModels = loans.map { LoanViewModel(loan: $0) }

            DispatchQueue.main.async {
                self.loans = loanViewModels
            }
        })
    }
}
