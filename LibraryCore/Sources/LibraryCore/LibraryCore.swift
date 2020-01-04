import Foundation

import os

fileprivate let log = OSLog(subsystem: .libraryCore, category: .development)

public struct LibraryCore {

    public static func clearKeychain() throws {
        os_log(.info, log: log, "Clearing Keychain")

        let keychainManager = KeychainManager()

        try keychainManager.clear()
    }
}
