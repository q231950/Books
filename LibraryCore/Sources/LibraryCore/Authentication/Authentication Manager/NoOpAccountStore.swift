//
//  NoOpAccountStore.swift
//  
//
//  Created by Kim Dung-Pham on 04.01.20.
//

import Foundation

struct NoOpAccountStore: AccountStoring {

    var accountPublisher: AccountPublisher

    func storeSignedInAccountIdentifier(_ identifier: String) {
        // no op…
    }

    func removeSignedInAccountIdentifier(_ identifier: String) {
        // no op…
    }

    func signedInAccountIdentifier() -> String? {
        nil
    }

}
