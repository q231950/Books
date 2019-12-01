//
//  AccountCredentialStore.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 18.12.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation

/// The Account Credential Store provides
/// a facility to store account credentials
class AccountCredentialStore {

    let keychainProvider: KeychainProvider

    /// The account credential store requires a keychain provider to store and retrieve passwords and account from.
    /// - parameter keychainProvider: The keychain provider to use
    init(keychainProvider: KeychainProvider) {
        self.keychainProvider = keychainProvider
    }

    /// Stores the given credential. Storing the credential might throw an error when the underlying keychain provider fails to add the password and username.
    /// - parameter password: The password to store
    /// - parameter identifier: The account identifier the password belongs to
    func store(_ password: String, of identifier: String) throws {
        try keychainProvider.add(password: password, to: identifier)
    }

    /// Delete a credential from the store.
    /// - parameter identifier: The account identifier belonging to the password to remove
    func removePassword(for identifier: String) {
        keychainProvider.deletePassword(of: identifier)
    }

    /// Get the password of a user with the given user identifier
    /// - parameter accountIdentifier: The user account's identifier
    func password(for accountIdentifier: String?) -> String? {
        guard let accountIdentifier = accountIdentifier else {
            return nil
        }
        return keychainProvider.password(for: accountIdentifier)
    }
}
