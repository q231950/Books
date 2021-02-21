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
            AppContainerView()
                .accentColor(Color("accent"))
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }

    public init() {

#if DEBUG
        let processInfo = ProcessInfo()

        handleProcessInfo(processInfo)
#endif
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
