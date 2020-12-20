//
//  AccountStoringProtocol.swift
//  
//
//  Created by Kim Dung-Pham on 04.01.20.
//

import Foundation

public protocol AccountStoring {
    func storeAccount(identifier: String)
    func defaultAccountIdentifier() -> String?
}
