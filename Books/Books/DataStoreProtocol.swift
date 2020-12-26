//
//  DataStoreProtocol.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 13.11.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation
import CoreData

protocol DataStore {

    /// The persistent container of the DataStore can be used to fetch items from its contexts or create new ones
    var container: NSPersistentContainer { get }

    /// Saves the current state of the store
    func saveViewContext()
}
