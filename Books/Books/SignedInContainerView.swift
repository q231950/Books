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

    var body: some View {
        TabView(selection: $selection){
            authentication.loansViewModel.map({ LoansView(loansViewModel: $0) })
            AccountView(authenticationViewModel: authentication)
        }
    }
}
