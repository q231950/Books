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
    @EnvironmentObject private var libraryCore: LibraryCore
    @ObjectBinding var authentication: Authentication
    var body: some View {
        Group {
            if libraryCore.authentication.authenticated == true {
                TabbedView(selection: $selection){
                    LoansView()
                    AccountView()
                }
            } else {
                VStack() {
                    TextField($libraryCore.account.username.binding)

                    TextField($libraryCore.account.password.binding) {
                        self.libraryCore.authenticate()
                    }
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        let authentication = Authentication()
        let libraryCore = LibraryCore()
        return ContentView(authentication: authentication).environmentObject(libraryCore)
    }
}
#endif

