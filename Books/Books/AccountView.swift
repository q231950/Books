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
    var body: some View {
        return VStack {
            Text("Account View")
            Button(action: authenticationViewModel.signOut) {
                Text("SignOut")
            }
        }
            .tabItem { Text("Account") }
            .tag(1)
    }
}


#if DEBUG
struct AccountView_Previews : PreviewProvider {
    static var previews: some View {
        let accountViewModel = AccountViewModel(account: Account())
        let authenticationViewModel = AuthenticationViewModel(accountViewModel: accountViewModel)
        return AccountView(authenticationViewModel: authenticationViewModel)
    }
}
#endif
