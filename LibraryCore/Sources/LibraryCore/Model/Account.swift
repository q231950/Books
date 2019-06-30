//
//  Account.swift
//  
//
//  Created by Martin Kim Dung-Pham on 15.06.19.
//

import Foundation
import SwiftUI
import Combine

public struct Account {
    public var username: String = "" {
        didSet {
                self.didChange.send(self)
        }
    }

    public var password: String = "" {
        didSet {
            self.didChange.send(self)
        }
    }

    public var didChange = PassthroughSubject<Account, Never>()

    public init() {

    }
}
