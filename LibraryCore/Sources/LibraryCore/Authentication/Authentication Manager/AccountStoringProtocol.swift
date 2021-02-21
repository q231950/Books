//
//  AccountStoringProtocol.swift
//  
//
//  Created by Kim Dung-Pham on 04.01.20.
//

import Foundation
import Combine

public typealias AccountPublisher = CurrentValueSubject<AccountModel?, Never>

public protocol AccountStoring {

    var accountPublisher: AccountPublisher { get }

    func storeSignedInAccountIdentifier(_ identifier: String)
    func removeSignedInAccountIdentifier(_ identifier: String)
    func signedInAccountIdentifier() -> String?
}
