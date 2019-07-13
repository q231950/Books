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
    @ObjectBinding var loansViewModel: LoansViewModel
    var body: some View {
        return VStack{
            List(loansViewModel.loans.identified(by: \.identifiedValue)) { loanViewModel in
                LoanView(loanViewModel: loanViewModel)
            }
            }
            .tag(0)
            .tabItemLabel(
                Text("Loans"))
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
