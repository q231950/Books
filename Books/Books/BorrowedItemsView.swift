//
//  BorrowedItemsView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore
import Combine

struct BorrowedItemsView : View {
    @ObservedObject var viewModel: BorrowedItemsViewModel = BorrowedItemsViewModel()
    var body: some View {
        return
            VStack {
                List(viewModel.borrowedItems, id: \.identifier) { loan in
                    LoanRow(loanViewModel: BorrowedItemViewModel(loan: loan))
                    .padding()
                }
                .listStyle(PlainListStyle())
            }
            .tag(0)
            .tabItem { Text("Loans") }
    }
}


//#if DEBUG
//    struct BorrowedItemsView_Previews : PreviewProvider {
//        static var previews: some View {
//
//            let account = AccountModel(credentials: Credentials().withUsername("abc").withPassword("123"))
//            let authenticationManager = AuthenticationManager(accountStore: AccountStore())
//            let borrowedItemsViewModel = BorrowedItemsViewModel(account: account, authenticationManager: authenticationManager)
//            borrowedItemsViewModel.loans.append(loanViewModels[0])
//            borrowedItemsViewModel.loans.append(loanViewModels[1])
//
//            return Group {
//                BorrowedItemsView(borrowedItemsViewModel: borrowedItemsViewModel).previewDisplayName("Loans on light")
//                BorrowedItemsView(borrowedItemsViewModel: borrowedItemsViewModel)
//                .environment(\.colorScheme, .dark)
//                .previewDisplayName("Loans on dark")
//
//            }
//        }
//    }
//#endif
