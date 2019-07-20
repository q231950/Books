//
//  Environment.swift
//  
//
//  Created by Martin Kim Dung-Pham on 17.07.19.
//

import Foundation

///
/// An environment can be queried for whether or not the app has been launched in a testing environment.
///
/// Application logic can (carefully) take different code paths for testing purposes. For exampe, Xcode UI Tests
/// should not run against the production backend - a testing environment might provide an alternate server
/// for network requests or stubbornly stub requests.
///
public struct Environment {
    public static var testing: Bool {
        get {
            let p = ProcessInfo()
            let testingAsString = p.environment["TESTING"]
            return testingAsString != nil
        }
    }
}
