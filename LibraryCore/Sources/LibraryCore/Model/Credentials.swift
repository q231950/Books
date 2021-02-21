//
//  Credentials.swift
//  
//
//  Created by Kim Dung-Pham on 02.01.21.
//

import Foundation
import Combine

public struct Credentials {
    public let username: String
    public let password: String

    public var isValid: Bool {
        !username.isEmpty && !password.isEmpty
    }

    public init() {
        self.init(username: "", password: "")
    }

    private init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    public func withUsername(_ username: String) -> Credentials {
        Credentials(username: username, password: password)
    }

    public func withPassword(_ password: String) -> Credentials {
        Credentials(username: username, password: password)
    }
}

public protocol CredentialsProvider {
    var credentialsPublisher: PassthroughSubject<Credentials, Never> { get }
}

