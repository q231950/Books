//
//  UserDefaults+Keys.swift
//  
//
//  Created by Martin Kim Dung-Pham on 28.11.19.
//

import Foundation

internal extension UserDefaults {
    enum Keys {
        static let currentAccountIdentifier = "current account identifier"
        fileprivate static let suite = "com.elbedev.librarycore"
    }
}

internal extension UserDefaults {
    static var libraryCoreDefaults = UserDefaults.init(suiteName: UserDefaults.Keys.suite)

    func clear() {
        UserDefaults.libraryCoreDefaults?.removeObject(forKey: Keys.currentAccountIdentifier)
    }
}
