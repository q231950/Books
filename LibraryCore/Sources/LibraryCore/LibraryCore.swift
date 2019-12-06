import Foundation

public struct LibraryCore {
    typealias Keys = UserDefaults.Keys

    /// The key to the default account identifier if there is any
    public static var defaultAccountIdentifier: String? {
        return UserDefaults.standard.string(forKey: Keys.defaultAccountIdentifier)
    }

    /// Clears the defaults of LibraryCore
    public static func clearDefaults() {
        UserDefaults.standard.clear()
    }
}
