//
//  LoansView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore
import Combine

struct LoansView : View {
    @ObservedObject var loansViewModel: LoansViewModel
    var body: some View {
        return
            VStack {
                List(loansViewModel.loans, id: \.identifier) { loanViewModel in
                    LoanRow(loanViewModel: loanViewModel)
                }
            }
            .tag(0)
            .tabItem { Text("Loans") }
    }
}


#if DEBUG
    struct LoansView_Previews : PreviewProvider {
        static var previews: some View {

            let account = AccountModel(username: "abc", password: "123")
            let authenticationManager = AuthenticationManager(accountStore: AccountStore())
            let loansViewModel = LoansViewModel(account: account, authenticationManager: authenticationManager)
            loansViewModel.loans.append(loanViewModels[0])
            loansViewModel.loans.append(loanViewModels[1])

            return Group {
                LoansView(loansViewModel: loansViewModel).previewDisplayName("Loans on light")
                LoansView(loansViewModel: loansViewModel)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Loans on dark")

            }
        }
    }
#endif
