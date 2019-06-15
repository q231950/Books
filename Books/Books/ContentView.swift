//
//  ContentView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore

struct ContentView : View {
    @State private var selection = 0
    @ObjectBinding var authentication: Authentication
    
    var body: some View {
        Group {
            if self.authentication.authenticated == true {
                TabbedView(selection: $selection){
                    LoansView()
                    AccountView()
                }
            } else {
                Text("Not authenticated")
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        let authentication = Authentication()
        return ContentView(authentication: authentication)
    }
}
#endif

