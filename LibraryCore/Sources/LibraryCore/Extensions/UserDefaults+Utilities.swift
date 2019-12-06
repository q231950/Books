//
//  UserDefaults+Utilities.swift
//  
//
//  Created by Martin Kim Dung-Pham on 28.11.19.
//

import Foundation

internal extension UserDefaults {

    /// The keys used within the _LibraryCore_ to store data into `UserDefaults`
    enum Keys {
        static let defaultAccountIdentifier = "default account identifier"
    }
}

internal extension UserDefaults {

    /// This method clears the `UserDefaults` from all keys used by the _LibraryCore_
    func clear() {
        self.removeObject(forKey: Keys.defaultAccountIdentifier)
    }
}
