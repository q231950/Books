//
//  SignedOutView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 30.10.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore

/// This is the view that people get to see when they are signed out
struct SignedOutView : View {
    @ObservedObject var authentication: AuthenticationViewModel

    var body: some View {
        VStack(){
            HStack() {
                Spacer()
                TextField("username", text: $authentication.accountViewModel.account.username)
                Spacer()
            }
            HStack() {
                Spacer()
                TextField("password", text: $authentication.accountViewModel.account.password)
                Spacer()
            }
            HStack() {
                Spacer()
                Button(action: {
                    self.authentication.authenticate()
                }) {
                    Text("Sign in")
                }
                Spacer()
            }
        }
    }
}
