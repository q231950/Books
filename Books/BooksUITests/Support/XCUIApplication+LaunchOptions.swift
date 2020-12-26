//
//  XCUIApplication+launchOptions.swift
//  BooksUITests
//
//  Created by Kim Dung-Pham on 20.12.20.
//  Copyright © 2020 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation
import XCTest

extension XCUIApplication {

    /// Allows to apply options to the launch of an `XCUIApplication`.
    ///
    /// The following code will launch an `XCUIApplication` with 2 options:
    /// 1. *stub* all network requests or record a new stub if none exists yet
    /// 2. *clean* all keychain and persistent data when the app launches
    ///
    /// *Example*
    ///
    /// ```
    /// app = XCUIApplication()
    /// app.launch(options: [.stub(.networkRequests, in: self), .clean])
    /// ```
    ///
    /// - Parameter options: the options to apply.
    func launch(options: [LaunchOption]) {

        for option in options {
            addOption(option)
        }

        launch()
    }
}

/// Launch options to apply to the launch of an `XCUIApplication`
///
enum LaunchOption {
    /// This option tells the application to either playback stubbed network
    /// requests for the given test case or record a new stub if none exists yet.
    case stub(_ subject: StubbingSubject, `in`: XCTestCase)
    /// This option tells the application to clear the keychain.
    case cleanKeychain
    /// This option tells the application to use a custom location to store data.
    case customDataStore(name: String)
}

/// The subject to be stubbed.
enum StubbingSubject {
    /// Currently, only network requests can be stubbed in UI Tests
    case networkRequests
}

extension XCUIApplication {
    func addOption(_ option: LaunchOption) {
        let processInfo = ProcessInfo()

        switch option {
        case .stub(_, let test):
            launchEnvironment["STUB_PATH"] = "\(processInfo.environment["PROJECT_DIR"] ?? "")/BooksUITests/Stubs"
            launchEnvironment["THE_STUBBORN_NETWORK_UI_TESTING"] = "YES"
            launchEnvironment["STUB_NAME"] = test.name
        case .cleanKeychain:
            launchArguments.append("cleanKeychain")
        case .customDataStore(let name):
            launchEnvironment["DATASTORE_PATH"] = "\(processInfo.environment["PROJECT_DIR"] ?? "")/BooksUITests/DataStores/\(UUID().uuidString)/\(name)"
        }
    }

    func removeOption(_ option: LaunchOption) {

        switch option {
        case .stub:
            launchEnvironment.removeValue(forKey: "STUB_PATH")
            launchEnvironment.removeValue(forKey: "THE_STUBBORN_NETWORK_UI_TESTING")
            launchEnvironment.removeValue(forKey: "STUB_NAME")
        case .cleanKeychain:
            launchArguments.removeAll(where: { $0 == "cleanKeychain" })
        case .customDataStore:
            launchEnvironment.removeValue(forKey: "DATASTORE_PATH")
        }
    }
}
