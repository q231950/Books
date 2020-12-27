//
//  SignedInContainerView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 30.10.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore

struct SignedInContainerView : View {
    @State private var selection = 0
    @ObservedObject var authentication: AuthenticationViewModel
    @State private var showingAccount = false

    var body: some View {
        NavigationView {
            authentication.loansViewModel.map({ LoansView(loansViewModel: $0) })
                .navigationBarTitle(Text("BTLB"))
                .navigationBarItems(trailing: Button(action: {
                    showingAccount.toggle()
                }) {
                    Image(systemName: "person.crop.circle").imageScale(Image.Scale.large)
                        .accessibility(identifier: "Account")
                }.sheet(isPresented: $showingAccount) {
                    AccountView(authenticationViewModel: self.authentication)
                })
        }
    }
}

#if DEBUG

struct SignedIn_preview: PreviewProvider {

    static var previews: some View {
        let accountViewModel = AccountViewModel(account: AccountModel())
        let authenticationManager = AuthenticationManager(accountStore: AccountStore())
        let authenticationViewModel = AuthenticationViewModel(authenticationManager: authenticationManager, accountViewModel: accountViewModel)
        return SignedInContainerView(authentication: authenticationViewModel)
    }
}

#endif
