//
//  LoanView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 13.07.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore

struct LoanRow : View {
    var loanViewModel: LoanViewModel

    var body: some View {
        VStack {
            loanViewModel.loan.map({ loan in
                NavigationLink(destination: LoanDetailView(loanViewModel: loanViewModel)) {
                    VStack(alignment: .leading) {
                        loan.title.map({ s in
                            Text(s)
                                .font(.headline)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                        })
                        loan.author.map({ s in
                            Text(s)
                                .font(.subheadline)
                        })
                        HStack(alignment: .bottom) {
                            loan.signature.map({ s in
                                Text(s)
                                    .font(.body)
                            })
                            Spacer()
                            loan.expiryDateString.map({ d in
                                Text("\(d)")
                                    .foregroundColor(Color("gray text"))
                                    .font(.body)
                                    .bold()

                            })
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    }
                }
            })
        }
        .accessibility(identifier: loanViewModel.loan?.identifier ?? "n/a")
        .accessibility(label: Text(loanViewModel.loan?.title ?? "n/a"))
    }
}

#if DEBUG
struct LoanRow_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            LoanRow(loanViewModel: loanViewModels[0])
                .environment(\.colorScheme, .dark)
                .previewLayout(.fixed(width: 300, height: 100))
                .previewDisplayName("Loan on dark")

            LoanRow(loanViewModel: loanViewModels[1])
                .previewLayout(.fixed(width: 300, height: 100))
                .previewDisplayName("Loan on light")
        }
    }
}

var loanViewModels: [LoanViewModel] {
    let loan1 = FlamingoLoan()
    loan1.expiryDate = Date(timeIntervalSinceNow: 3600*48)
    loan1.title = "Akira"
    loan1.author = "Kodansha"
    loan1.signature = "123456789-abc"
    let viewModel1 = LoanViewModel(loan: loan1)


    let loan2 = FlamingoLoan()
    loan2.expiryDate = Date(timeIntervalSinceNow: 3600*24)
    loan2.title = "War and Peace"
    loan2.author = "Leo Tolstoy"
    loan2.signature = "222222-bbb"
    let viewModel2 = LoanViewModel(loan: loan2)

    return [viewModel1, viewModel2]
}
#endif
