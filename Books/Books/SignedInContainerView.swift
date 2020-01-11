//
//  SignedInContainerView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 30.10.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI

struct SignedInContainerView : View {
    @State private var selection = 0
    @ObservedObject var authentication: AuthenticationViewModel
    @State private var showingAccount = false

    var body: some View {
        NavigationView {
            authentication.loansViewModel.map({ LoansView(loansViewModel: $0) })
                .navigationBarTitle(Text("BTLB"))
                .navigationBarItems(trailing: Button(action: {
                    self.showingAccount.toggle()
                }) {
                    Image(systemName: "person.crop.circle").imageScale(Image.Scale.large)
                        .accentColor(.pink)
                        .accessibility(identifier: "Account")
                }.sheet(isPresented: $showingAccount) {
                    AccountView(authenticationViewModel: self.authentication)
                })
        }
    }
}
