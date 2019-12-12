//
//  KeychainManager.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 09.09.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation

protocol KeychainProvider {

    /**
     Stores a password of an account in the keychain
     Parameters:
     - parameter password: The password to store
     - parameter accountIdentifier: The identifier of the belonging account
     */
    func add(password: String, to account: String) throws

    /**
     Deletes the password of the given account
     Parameters:
     - parameter account: The account the password to delete belongs to.
     */
    func deletePassword(of account: String)

    /**
     Retrieve a password belonging to an account
     - returns: The optional session identifier if one was found
     - parameter account: The account to retrieve the password for
     */
    func password(for account: String) -> String?
}

class KeychainManager: KeychainProvider {

    func add(password: String, to account: String) throws {
        deletePassword(of: account)
        let accountData = account.data(using: .utf8)!
        let identifierData = password.data(using: .utf8)!
        let addquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: accountData,
                                       kSecValueData as String: identifierData]

        let status = SecItemAdd(addquery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "com.elbedev.books.KeychainManager", code: 1) }
    }

    func password(for account: String) -> String? {
        let accountData = account.data(using: .utf8)!
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: accountData,
                                       kSecReturnData as String: kCFBooleanTrue as Any,
                                       kSecMatchLimit as String: kSecMatchLimitOne]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            let err = NSError(domain: "com.elbedev.books.KeychainManager", code: 2)
            print(err)
            return nil
        }
        guard let x = item as? Data,
            let identifier = String(data:x, encoding: .utf8) else {
                return nil
        }

        return identifier
    }

    func deletePassword(of account: String) {
        let query = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrAccount : account
            ] as CFDictionary

        SecItemDelete(query)
    }

    func clear() throws {
        let secItemClasses = [
            kSecClassGenericPassword
        ]

        // search for items to remove
        for secItemClass in secItemClasses {
            let query: [String: Any] = [
                kSecReturnAttributes as String: kCFBooleanTrue as Any,
                kSecMatchLimit as String: kSecMatchLimitAll,
                kSecClass as String: secItemClass
            ]

            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            if status == noErr {
                if let items = result as? [NSDictionary] {
                    for dict in items {
                        if let data = dict["acct"] as? Data,
                            let account = String(data: data, encoding: .utf8) {
                            os_log(.default, log: log, "Clearing Account (%{public}@) from Keychain.", account)
                            deletePassword(of: account)
                        }
                    }
                }
            }
        }
    }
}
