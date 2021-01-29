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
    @ObservedObject var accountViewModel: AccountViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("my name")

            Button(action: {
                presentationMode.wrappedValue.dismiss()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.34) {
                    AppEnvironment.current.authenticationInteractor.signOut()
                }
            }) {
                Text("Sign out")
            }
        }
        .tabItem { Text("Account") }
    }
}


#if DEBUG
//struct AccountView_Previews : PreviewProvider {
//    static var previews: some View {
//        let accountViewModel = AccountViewModel(account: AccountModel())
//        let authenticationManager = AuthenticationManager(accountStore: AccountStore())
//        let authenticationViewModel = AuthenticationViewModel(authenticationManager: authenticationManager, accountViewModel: accountViewModel)
//        return AccountView(authenticationViewModel: authenticationViewModel)
//    }
//}
#endif
