import Combine
import SwiftUI

public struct Account {
    public init() {}
}

@available(iOS 13.0, *)
public class LibraryCore {
    let authenticationManager = AuthenticationManager()
    public var authentication = Authentication()

    public init() {}

    public func authenticate() {
        authenticationManager.authenticateAccount("") { (valid, error) in
            self.authentication.authenticated = valid
        }
    }
}

@available(iOS 13.0, *)
public class Authentication: BindableObject {

    public var authenticated: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }

    public init() {}

    public var didChange = PassthroughSubject<Authentication, Never>()
}
