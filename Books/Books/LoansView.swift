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
        return VStack{
            Text("🌊")
            List(loansViewModel.loans, id: \.identifier) { loanViewModel in
                LoanView(loanViewModel: loanViewModel)
            }
        }
        .tag(0)
        .tabItem { Text("Loans") }
    }
}


#if DEBUG
//    struct LoansView_Previews : PreviewProvider {
//        static var previews: some View {
//            let loansViewModel = LoansViewModel(account: <#T##Account#>, authenticationManager: <#T##AuthenticationManager#>)
//            return LoansView(loansViewModel: loansViewModel)
//        }
//    }
#endif
