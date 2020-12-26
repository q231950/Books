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
    enum RenewalState {
        case idle, renewing, renewed, error
    }

    @State var isRenewing: Bool = false
    @State var renewalState: RenewalState = .idle
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    let loanViewModel: LoanViewModel

    var body: some View {
        if renewalState == .renewing {
            return renewingBody()
        } else if renewalState == .renewed {
            return AnyView(standardBody().alert(isPresented: .constant(true)) {
                Alert(title: Text("Renewed"), message: Text("The item has been renewed."), dismissButton: .default(Text("Ok")))
            })
        } else if renewalState == .error {
            return AnyView(standardBody().alert(isPresented: .constant(true)) {
                Alert(title: Text("Not Renewed"), message: Text("The item has not been renewed!"), dismissButton: .default(Text("Ok")))
            })
        } else {
            return standardBody()
        }
    }


    private func renewingBody() -> AnyView {
        AnyView(ActivityIndicator(isAnimating: $isRenewing, style: .medium))
    }

    private func standardBody() -> AnyView {
        AnyView(
            loanViewModel.loan.map { loan in
                Group {
                    VStack(alignment: .leading) {
                        Spacer().frame(height:20)

                        Text(loanViewModel.loan?.title ?? "Unknown Item")
                            .font(.largeTitle)

                        Text("\(loan.author ?? "")")
                            .font(.headline)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))

                        Spacer().frame(height:50)

                        properties(for: loan)

                        Spacer().frame(height:50)

                        dates(for: loan)

                        Spacer()

                        renewButton(loan: loan)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                .navigationBarTitle(Text("Details"), displayMode: .inline)
            })
    }

    private func renewButton(loan: FlamingoLoan) -> some View {
        Group {
            if (loan.renewable == true) {
                HStack {
                    Button(action: {
                        self.isRenewing = true
                        self.renewalState = .renewing
                        APIClient.shared.renew(account: self.authenticationViewModel.accountViewModel.account,
                                                           accountStore: AccountStore(),
                                                           itemIdentifier: self.loanViewModel.loan?.barcode ?? "") { renewStatus in
                            self.isRenewing = false
                            self.onRenewal(status: renewStatus, loan: loan)
                        }
                    }) {
                        Text("Renew")
                            .font(.callout)
                            .bold()
                            .padding(EdgeInsets(top: 4, leading: 20, bottom: 6, trailing: 20))
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black.opacity(0.8), lineWidth: 2)
                            )
                    }
                    .accessibility(identifier: "Renew")
                }

            } else {
                HStack {
                    Button(action: {}) {
                        Text("No renewal possible")
                            .font(.callout)
                            .bold()
                            .padding(EdgeInsets(top: 4, leading: 20, bottom: 6, trailing: 20))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.black.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 2)
                            )
                    }
                    .disabled(true)
                    .accessibility(identifier: "No renewal possible")
                    .padding()
                }
            }
        }
        .padding(.bottom, 20)
    }

    private func properties(for loan: FlamingoLoan) -> AnyView {
        AnyView(
            VStack {
                HStack {
                    Text("\(loan.signature ?? "")")
                        .font(.body)
                        .foregroundColor(Color("gray text"))
                    Spacer()
                }

                HStack {
                    Text("\(loan.isbn ?? "")")
                        .font(.body)
                        .foregroundColor(Color("gray text"))
                    Spacer()
                }

                Spacer().frame(height:10)

                HStack {
                    Text("\(loan.materialName ?? "")")
                        .font(.body)
                        .foregroundColor(Color("gray text"))
                    Spacer()
                }
            }
        )
    }

    private func dates(for loan: FlamingoLoan) -> AnyView {
        AnyView(
            VStack {
                HStack {
                    Text("since")
                        .font(.body)
                        .foregroundColor(Color("gray text"))

                    Text("\(loan.dateIssuedString ?? "unknown")")
                        .foregroundColor(Color("gray text"))
                        .bold()

                    Spacer()
                }

                HStack {
                    if (loan.renewalDateString != nil) {
                        Text("renewed")
                            .font(.body)
                            .foregroundColor(Color("gray text"))

                        Text("\(loan.renewalDateString ?? "never")")
                            .foregroundColor(Color("gray text"))
                            .bold()

                    } else {
                        Text("never renewed")
                            .foregroundColor(Color("gray text"))
                    }

                    Text("/")
                        .font(.body)
                        .foregroundColor(Color("gray text"))

                    Text("due")
                        .font(.body)
                        .foregroundColor(Color("gray text"))

                    Text("\(loan.expiryDateString ?? "unknown")")
                        .foregroundColor(Color("gray text"))
                        .bold()

                    Spacer()
                }
            }
        )
    }

    @State private var renewalAlertContent: (title: String, message: String)?

    private func onRenewal(status: RenewStatus, loan: FlamingoLoan) {
        var title: String
        var message: String

        switch status {
        case .success(let s):
            title = "Success"
            message = "The item has been renewed (\(s))."
            let dateFormatter = FlamingoLoan.dateFormatter()
            loan.renewalDate = dateFormatter.date(from: s)
            self.renewalState = .renewed
        case .error(let err):
            title = "Error"
            message = "An error occurred when renewing the item (\(err))."
            self.renewalState = .error
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
        let loan = FlamingoLoan()
        loan.expiryDate = Date()
        loan.title = "A Zoo in Winter A Zoo in Winter A Zoo in Winter"
        loan.author = "Jiro Taniguchi"
        loan.signature = "Comic.9"
        loan.recNo = "RecNo"
        loan.isbn = "978-3-642-04717-6"
        loan.ean = ""
        loan.borrowedDate = Date(timeIntervalSinceNow: -3600 * 24 * 7)
        loan.issuedToday = "IssuedToday"
        loan.overdue = false
        loan.recalled = false
        loan.renewalCount = 0
        loan.renewalFee = "3.2"
        loan.renewalDate = nil
        loan.renewedToday = false
        loan.locationIssued = "001"
        loan.locationIssuedName = "Zentralbibliothek"
        loan.material = "Material"
        loan.materialName = "Buch Erwachsene"
        loan.isReserved = false
        let viewModel = LoanViewModel(loan: loan)
        return LoanDetailView(loanViewModel: viewModel)
            .environment(\.colorScheme, .light)
    }
}
#endif
