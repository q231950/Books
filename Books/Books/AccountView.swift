//
//  AccountView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore

struct AccountView : View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        return VStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.34) {
                    self.authenticationViewModel.signOut()
                }
            }) {
                Text("Sign out")
            }
        }
        .tabItem { Text("Account") }
        .tag(1)
    }
}


#if DEBUG
struct AccountView_Previews : PreviewProvider {
    static var previews: some View {
        let accountViewModel = AccountViewModel(account: AccountModel())
        let authenticationManager = AuthenticationManager(accountStore: AccountStore())
        let authenticationViewModel = AuthenticationViewModel(authenticationManager: authenticationManager, accountViewModel: accountViewModel)
        return AccountView(authenticationViewModel: authenticationViewModel)
    }
}
#endif
