//
//  ContentView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore
import Combine

struct ContentView : View {
    @State private var selection = 0
    @ObjectBinding var authentication: AuthenticationViewModel
    @ObjectBinding var account: AccountViewModel
    var body: some View {
        Group {
            if authentication.authenticated {
                TabbedView(selection: $selection){
                    LoansView()
                    AccountView()
                }
            } else {
                VStack(){
                    HStack() {
                        Spacer()
                        TextField($account.account.username.binding, placeholder: Text("username"))
                        Spacer()
                    }
                    HStack() {
                        Spacer()
                        TextField($account.account.password.binding, placeholder: Text("password")) {
                        }
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
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        let accountViewModel = AccountViewModel(account: Account())
        let authenticationViewModel = AuthenticationViewModel()
        return ContentView(authentication: authenticationViewModel, account: accountViewModel)
    }
}
#endif

