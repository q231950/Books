//
//  AccountStore.swift
//  Books
//
//  Created by Kim Dung-Pham on 04.01.20.
//  Copyright © 2020 Martin Kim Dung-Pham. All rights reserved.
//

import LibraryCore
import CoreData
import UIKit

import os

fileprivate let log = OSLog(subsystem: .accountStore, category: .development)

struct AccountStore {
    func clearAccounts() {
        os_log(.info, log: log, "Clearing accounts.")
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.dataStore.persistentContainer.newBackgroundContext()
            do {
                let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
                let accounts = try context.fetch(fetchRequest)
                _ = accounts.map { context.delete($0)}
                try context.save()
            } catch {
                // do nothing
                print("\(error)")
            }
        }
    }
}

extension AccountStore: AccountStoring {
    func storeAccount(identifier: String) {
        os_log(.info, log: log, "Storing account identifier: %{private}@", identifier)

        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.dataStore.persistentContainer.viewContext
                do {
                    let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
                    let accounts = try context.fetch(fetchRequest)
                    _ = accounts.map { context.delete($0)}
                    let account = Account.init(entity: Account.entity(), insertInto: context)
                    account.username = identifier
                    try context.save()
                } catch {
                    // do nothing..
                }
            }
        }
    }

    func defaultAccountIdentifier() -> String? {
        var identifier: String?

        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                do {
                    let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
                    let accounts = try appDelegate.dataStore.persistentContainer.viewContext.fetch(fetchRequest)
                    identifier = accounts.first?.username
                } catch {
                    // do nothing..
                }
            }
        }

        os_log(.info, log: log, "Accessing default account identifier: %{private}@", identifier ?? "nil")

        return identifier
    }
}
