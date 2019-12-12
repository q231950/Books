import Foundation

import os

fileprivate let log = OSLog(subsystem: .defaults, category: .development)

public struct LibraryCore {
    typealias Keys = UserDefaults.Keys

    /// The key to the default account identifier if there is any
    public static var defaultAccountIdentifier: String? {
        let identifier = UserDefaults.standard.string(forKey: Keys.defaultAccountIdentifier)
        os_log(.info, log: log, "Accessing defaultAccountIdentifier: %{public}@", identifier ?? "nil")
        return identifier
    }

    /// Resets the defaults of LibraryCore
    public static func resetUserDefaults() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            os_log(.info, log: log, "Resetting standard UserDefaults")
            UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
        }
    }

    public static func clearKeychain() throws {
        let keychainManager = KeychainManager()

        try keychainManager.clear()
    }
}
