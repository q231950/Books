//
//  LoanView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 13.07.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore

struct LoanView : View {
    @ObjectBinding var loanViewModel: LoanViewModel

    var body: some View {
        return VStack {
            loanViewModel.loan.map({ loan in
                VStack(alignment: .leading) {
                    loan.title.map({ s in
                        Text(s)
                            .font(.title)
                    })
                    loan.author.map({ s in
                        Text(s)
                            .font(.headline)
                    })
                    loan.signature.map({ s in
                        Text(s)
                            .font(.subheadline)
                    })
                }
            })
        }
    }
}

#if DEBUG
struct LoanView_Previews : PreviewProvider {
    static var previews: some View {
        var loan = Loan()
        loan.identifier = "abc"
        let viewModel = LoanViewModel(loan: loan)
        return LoanView(loanViewModel: viewModel)
    }
}
#endif
