//
//  UserDefaults+UtilitiesTests.swift
//  
//
//  Created by Martin Kim Dung-Pham on 05.12.19.
//

import XCTest
@testable import LibraryCore

class UserDefaultsUtilitiesTests: XCTestCase {

    let customUserDefaultsKeys = [
        UserDefaults.Keys.defaultAccountIdentifier
    ]

    func test_UserDefaults_clear_removesObjectsOfKnownKeys() {
        let defaults = UserDefaults.standard
        for key in customUserDefaultsKeys {

            // given
            defaults.set(1, forKey: key)

            // when
            LibraryCore.resetUserDefaults()

            // then
            XCTAssertNil(defaults.object(forKey: key))
        }

    }
}
