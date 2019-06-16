import Combine
import SwiftUI

/// LibraryCore represents the interface to the real world library
public class LibraryCore: BindableObject {

    // MARK: Private

    let authenticationManager = AuthenticationManager()
    public init() {}

    public var account: Account = Account() {
        didSet {
            didChange.send(self)
        }
    }

    // MARK: Public

    public var didChange = PassthroughSubject<LibraryCore, Never>()

    /// authentication is a bindable object that allows to observe the authentication state
    public let authentication = Authentication()

    public func authenticate() {
        authenticationManager.authenticateAccount(account.username) { (valid, error) in
            self.authentication.authenticated = valid
        }
    }
}
