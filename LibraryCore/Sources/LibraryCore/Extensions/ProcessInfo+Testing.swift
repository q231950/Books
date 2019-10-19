//
//  ProcessInfo+Testing.swift
//
//
//  Created by Martin Kim Dung-Pham on 19.10.19.
//

import Foundation

public extension ProcessInfo {
    /// Returns `true` if the `ProcessInfo` contains a `TESTING` environment variable.
    var testing: Bool {
        get {
            return environment["TESTING"] != nil
        }
    }
}
