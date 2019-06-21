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
    @ObjectBinding var authentication: Authentication
    @ObjectBinding var account: Account
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
                        TextField($account.username.binding, placeholder: Text("Username"))
                        Spacer()
                    }
                    HStack() {
                        Spacer()
                        TextField($account.password.binding, placeholder: Text("Password")) {
                            self.authentication.authenticate(account: self.account)
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
        let libraryCore = LibraryCore()
        return ContentView(authentication: libraryCore.authentication, account: libraryCore.account)
    }
}
#endif

