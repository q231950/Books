import Combine
import SwiftUI

/// LibraryCore represents the interface to the real world library
public class LibraryCore: BindableObject {

    public var didChange = PassthroughSubject<LibraryCore, Never>()

    /// authentication is a bindable object that allows to observe the authentication state
    public let authentication = Authentication()

    public var account: Account = Account()

    public init() {}
}
