//
//  NoOpAccountStore.swift
//  
//
//  Created by Kim Dung-Pham on 04.01.20.
//

import Foundation

struct NoOpAccountStore: AccountStoring {

    func storeAccount(identifier: String) {
        // no op..
    }

    func defaultAccountIdentifier() -> String? {
        nil
    }
}
