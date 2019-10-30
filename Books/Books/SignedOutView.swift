//
//  SignedOutView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 30.10.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI

/// This is the view that people get to see when they are signed out
struct SignedOutView : View {
    @ObservedObject var authentication: AuthenticationViewModel
    @ObservedObject var account: AccountViewModel

    var body: some View {
        VStack(){
            HStack() {
                Spacer()
                TextField("username", text: $account.account.username)
                Spacer()
            }
            HStack() {
                Spacer()
                TextField("password", text: $account.account.password)
                Spacer()
            }
            HStack() {
                Spacer()
                Button(action: {
                    self.authentication.authenticate(account: self.account)
                }) {
                    Text("Sign in")
                }
                Spacer()
            }
        }
    }
}
