//
//  Account.swift
//  
//
//  Created by Martin Kim Dung-Pham on 15.06.19.
//

import Combine

public struct AccountModel {

    public let credentials: Credentials

    public init(credentials: Credentials) {
        self.credentials = credentials
    }
}
