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

struct AccountStore {
    func clearAccounts() {
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
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            do {
                let accounts = try appDelegate.dataStore.persistentContainer.viewContext.fetch(fetchRequest)
                identifier = accounts.first?.username
            } catch {
                // do nothing..
            }
        }
        return identifier
    }
}
