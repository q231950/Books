//
//  Account.swift
//  
//
//  Created by Martin Kim Dung-Pham on 15.06.19.
//

import Foundation
import SwiftUI
import Combine

public class Account: BindableObject {
    public var username: String = "" {
        didSet {
            didChange.send(self)
        }
    }

    public var password: String = "" {
        didSet {
            didChange.send(self)
        }
    }

    init() {}

    public var didChange = PassthroughSubject<Account, Never>()
}
