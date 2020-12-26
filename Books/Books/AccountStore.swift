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

    let persistenceController = CoreDataDataStore.shared
}

extension AccountStore: AccountStoring {
    func storeAccount(identifier: String) {
        os_log(.info, log: log, "Storing account identifier: %{private}@", identifier)
        DispatchQueue.main.async {
            let context = persistenceController.container.viewContext
                do {
                    let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
                    let accounts = try context.fetch(fetchRequest)
                    _ = accounts.map { context.delete($0)}
                    let account = Account(entity: Account.entity(), insertInto: context)
                    account.username = identifier
                    try context.save()
                    os_log(.info, log: log, "Stored account identifier: %{private}@", identifier)
                } catch {
                    // do nothing..
                }
        }
    }

    func defaultAccountIdentifier() -> String? {
        var identifier: String?
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        do {
                let accounts = try persistenceController.container.viewContext.fetch(fetchRequest)
                identifier = accounts.first?.username
            } catch {
                // do nothing..
            }
        os_log(.info, log: log, "Accessing default account identifier: %{public}@", identifier ?? "nil")
        return identifier
    }
}
