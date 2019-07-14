//
//  KeychainMock.swift
//  LibraryCoreTests
//
//  Created by Martin Kim Dung-Pham on 09.09.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation
@testable import LibraryCore

protocol TestableKeychainProvider: KeychainProvider {
    var addedKeychainItems:[String:String] {get}
}

class KeychainMock: TestableKeychainProvider {

    var addedKeychainItems = [String:String]()

    func add(password: String, to account: String) throws {
        addedKeychainItems[account] = password
    }

    func password(for account: String) -> String? {
        return addedKeychainItems[account]
    }

    func deletePassword(of account: String) {
        addedKeychainItems.removeValue(forKey: account)
    }
}
