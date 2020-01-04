//
//  AppDelegate.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import UIKit
import CoreData
import LibraryCore
import StubbornNetwork

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let dataStore: DataStore = CoreDataDataStore()

    /// The standard entry point to the app as defined in UIApplicationDelegate.
    /// Pass in a `clean`launch argument in order to get a clean app environment from your tests if needed.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let processInfo = ProcessInfo()

        if processInfo.isUITesting {
            UIApplication.shared.windows.first?.layer.speed = 100
        }

        processInfo.arguments.forEach( {
            switch $0 {
            case "clean":
                cleanAppEnvironment()
            default:
                return
            }
        })

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        dataStore.saveViewContext()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    /// Cleans all user defaults for the application
    private func cleanAppEnvironment() {
        LibraryCore.resetUserDefaults()

        do {
            try LibraryCore.clearKeychain()
        } catch {
            print(error)
        }
    }

}
