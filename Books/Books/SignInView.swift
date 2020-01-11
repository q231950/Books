//
//  SignInView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 30.10.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore

/// This is the view that people get to see when they are signed out
struct SignInView : View {
    @ObservedObject var authentication: AuthenticationViewModel

    var body: some View {
        VStack(){
            Text("Please enter your credentials of the Public Library of Hamburg.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 80, leading: 0, bottom: 20, trailing: 0))
            HStack() {
                Spacer()
                TextField("username", text: $authentication.accountViewModel.account.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.username)
                    .accessibility(identifier: "user")
                Spacer()
            }
            HStack() {
                Spacer()
                TextField("password", text: $authentication.accountViewModel.account.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.password)
                    .accessibility(identifier: "password")
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
            Spacer()
        }
    }
}
