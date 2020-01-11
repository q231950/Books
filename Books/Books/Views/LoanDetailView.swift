//
//  LoanDetailView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 11.01.20.
//  Copyright © 2020 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore

struct LoanDetailView: View {
    @State var isRenewing: Bool = false
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    let loanViewModel: LoanViewModel

    var body: some View {
        if isRenewing {
            return renewingBody()
        } else {
            return standardBody()
        }
    }

    private func renewingBody() -> AnyView {
        AnyView(ActivityIndicator(isAnimating: $isRenewing, style: .medium))
    }

    private func standardBody() -> AnyView {
        AnyView(
            Group {
                renewButton
            }
        )
    }

    private var renewButton: AnyView {
        AnyView(
            Button(action: {
                self.isRenewing = true
                PublicLibraryScraper.default.renew(account: self.authenticationViewModel.accountViewModel.account,
                                                   accountStore: AccountStore(),
                                                   itemIdentifier: self.loanViewModel.loan?.barcode ?? "") { renewStatus in
                                                    self.isRenewing = false
                                                    self.onRenewal(status: renewStatus)
                }
            }) {
                Text("Renew")
            }
        )
    }

    private func onRenewal(status: RenewStatus) {
        var title: String
        var message: String

        switch status {
        case .success(let s):
            title = "Success"
            message = "The item has been renewed (\(s))."
        case .error(let err):
            title = "Error"
            message = "An error occurred when renewing the item (\(err))."
        case .failure:
            title = "Failure"
            message = "Item could not be renewed."
        }

        print("\(title): \(message)")
    }
}


#if DEBUG
struct LoanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let loan = Loan(expiryDate: Date())
        let viewModel = LoanViewModel(loan: loan)

        return LoanDetailView(loanViewModel: viewModel)
    }
}
#endif
