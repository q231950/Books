//
//  AccountCredentialStore.swift
//  BTLB
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
    /// - parameter accountIdentifier: The account identifier the password belongs to
    func store(_ password: String, of accountIdentifier: String) throws {
        let account = "com.elbedev.books.account.password.\(accountIdentifier)"
        try keychainProvider.add(password: password, to: account)
    }

    /// Delete a credential from the store.
    /// - parameter accountIdentifier: The account identifier belonging to the password to remove
    func removePassword(for accountIdentifier: String) {
        let account = "com.elbedev.books.account.password.\(accountIdentifier)"
        keychainProvider.deletePassword(of: account)
    }

    /// Get the password of a user with the given user identifier
    /// - parameter accountIdentifier: The user account's identifier
    func password(for accountIdentifier: String?) -> String? {
        guard let accountIdentifier = accountIdentifier else {
            return nil
        }
        let account = "com.elbedev.books.account.password.\(accountIdentifier)"
        return keychainProvider.password(for: account)
    }
}
