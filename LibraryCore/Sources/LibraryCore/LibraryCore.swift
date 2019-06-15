import Combine
import SwiftUI

/// LibraryCore represents the interface to the real world library
public class LibraryCore {

    // MARK: Private

    let authenticationManager = AuthenticationManager()
    public init() {}

    // MARK: Public

    /// authentication is a bindable object that allows to observe the authentication state
    public let authentication = Authentication()

    public func authenticate() {
        authenticationManager.authenticateAccount("") { (valid, error) in
            self.authentication.authenticated = valid
        }
    }
}
