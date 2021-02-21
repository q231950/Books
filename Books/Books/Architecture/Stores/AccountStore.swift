//
//  AccountStore.swift
//  Books
//
//  Created by Kim Dung-Pham on 04.01.20.
//  Copyright © 2020 Martin Kim Dung-Pham. All rights reserved.
//

import LibraryCore
import CoreData
import Combine

import os

class AccountStore {
    let persistenceController = CoreDataDataStore.shared

    private(set) var accountPublisher = AccountPublisher(nil)

    fileprivate let log = OSLog(subsystem: .accountStore, category: .development)

    private var disposeBag = Set<AnyCancellable>()
    private let authenticationManager: AuthenticationManager

    init(authenticationManager: AuthenticationManager) {

        self.authenticationManager = authenticationManager

        defer {
            authenticationManager.authenticationSubject?.sink(receiveValue: { [weak self] state in
                switch state {
                case .authenticationComplete(.authenticated(credentials: let credentials)):
                    self?.storeSignedInAccountIdentifier(credentials.username)
                    self?.loadAccountDetails(credentials: credentials)
                default:
                    break
                }
            })
            .store(in: &disposeBag)
        }
    }

    private func loadAccountDetails(credentials: Credentials) {

    guard let sessionIdentifier = authenticationManager.sessionIdentifier(for: credentials.username) else {
            return
        }

        APIClient.shared.account(sessionIdentifier) { result in
            switch result {
            case .success:
            //                    storeAccount(account)
                break
            case .failure:
                break
            }
        }

    }
}

extension AccountStore: AccountStoring {

    func storeSignedInAccountIdentifier(_ identifier: String) {
        os_log(.info, log: log, "Storing account identifier: %{private}@", identifier)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let context = self.persistenceController.container.viewContext
            do {
                let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
                let accounts = try context.fetch(fetchRequest)
                _ = accounts.map { context.delete($0)}
                let account = Account(entity: Account.entity(), insertInto: context)
                account.username = identifier
                try context.save()
                os_log(.info, log: self.log, "Stored account identifier: %{private}@", identifier)
            } catch {
                os_log(.error, log: self.log, "Failed to store account identifier: %{private}@", identifier)
            }
        }

    }

    func removeSignedInAccountIdentifier(_ identifier: String) {
        os_log(.info, log: log, "Removing account with identifier: %{private}@", identifier)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let context = self.persistenceController.container.viewContext
            do {
                let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "username = %@", identifier)
                let result = try context.fetch(fetchRequest)
                if let account = result.first {
                    context.delete(account)
                    try context.save()
                }
            } catch {
                os_log(.info, log: self.log, "Failed to remove  account with identifier: %{private}@", identifier)
            }
        }
    }

    func signedInAccountIdentifier() -> String? {
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
