//
//  BooksApp.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import UIKit
import SwiftUI
import LibraryCore

@main
struct BooksApp: App {

    let persistenceController = CoreDataDataStore.shared

    var body: some Scene {
        WindowGroup {
            makeContentView()
                .accentColor(Color("accent"))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }

    public init() {

#if DEBUG
        let processInfo = ProcessInfo()

        handleProcessInfo(processInfo)
#endif
    }

    private func makeContentView() -> some View {
        let authenticationViewModel = createAuthenticationViewModel()

        return ContentView(authenticationViewModel: authenticationViewModel).environmentObject(authenticationViewModel)
    }

    /// Create an authentication view model.
    private func createAuthenticationViewModel() -> AuthenticationViewModel {
        var account = AccountModel()
        let store = AccountStore()
        if let identifier = store.defaultAccountIdentifier() {
            account.username = identifier
        }

        let accountViewModel = AccountViewModel(account: account)
        let accountStore = AccountStore()
        return AuthenticationViewModel(authenticationManager: AuthenticationManager(accountStore: accountStore),
                                       accountViewModel: accountViewModel)
    }
}

#if DEBUG
fileprivate extension BooksApp {

    func handleProcessInfo(_ processInfo: ProcessInfo) {
        if processInfo.isUITesting {
            //UIApplication.shared.windows.first?.layer.speed = 100
        }

        processInfo.arguments.forEach( {
            switch $0 {
            case "cleanKeychain":
                self.clearKeychain()
            default:
                break
            }
        })
    }

    /// Cleans the keychain and any persisted data
    func clearKeychain() {
        do {
            try LibraryCore.clearKeychain()
        } catch {
            print(error)
        }
    }
}

#endif
