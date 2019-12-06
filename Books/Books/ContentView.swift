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
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    var body: some View {
        Group {
            if authenticationViewModel.authenticated {
                SignedInContainerView(authentication: authenticationViewModel)
                .padding(EdgeInsets(top: CGFloat(0), leading: CGFloat(10), bottom: CGFloat(0), trailing: CGFloat(10)))
            } else {
                SignInView(authentication: authenticationViewModel)
                .padding(EdgeInsets(top: CGFloat(0), leading: CGFloat(10), bottom: CGFloat(0), trailing: CGFloat(10)))
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        let accountViewModel = AccountViewModel(account: Account())
        let authenticationViewModel = AuthenticationViewModel(accountViewModel: accountViewModel)
        return ContentView(authenticationViewModel: authenticationViewModel)
    }
}
#endif

