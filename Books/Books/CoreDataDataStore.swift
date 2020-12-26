//
//  CoreDataDataStore.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 13.11.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation
import CoreData

class CoreDataDataStore {

    static var shared: CoreDataDataStore = {
        if ProcessInfo().isUITesting {
            return CoreDataDataStore(inMemory: true, path: ProcessInfo().environment["DATASTORE_PATH"])
        } else {
            return CoreDataDataStore()
        }
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false, path: String? = nil) {

        container = NSPersistentCloudKitContainer(name: "Books")
        if inMemory {
            let path = path ?? "/dev/null"
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: path)
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension CoreDataDataStore: DataStore {
    func saveViewContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
