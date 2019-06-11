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
    @EnvironmentObject var authentication: Authentication
    
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
