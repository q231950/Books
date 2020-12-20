//
//  Account.swift
//  
//
//  Created by Martin Kim Dung-Pham on 15.06.19.
//

import Combine

public struct AccountModel {
    public var username: String = ""
    public var password: String = ""

    public init() {
    }

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
