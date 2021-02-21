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
    @ObservedObject var viewModel: SignInViewModel
    let appContainerViewModel: AppContainerViewModel
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Please enter your credentials of the Public Library of Hamburg.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 80, leading: 0, bottom: 20, trailing: 0))

            TextField("username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.username)
                .accessibility(identifier: "user")

            TextField("password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.password)
                .accessibility(identifier: "password")

            Button(action: {
                AppEnvironment.current.authenticationInteractor.authenticate(credentials: Credentials()
                                                                                .withUsername(username)
                                                                                .withPassword(password))
            }) {
                Text("Sign in")
            }

            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .onReceive(viewModel.credentialsPublisher) { credentials in
            username = credentials.username
            password = credentials.password
        }
    }
}
