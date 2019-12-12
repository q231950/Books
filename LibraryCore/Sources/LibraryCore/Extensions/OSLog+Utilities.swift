//
//  OSLog+Utilities.swift
//  
//
//  Created by Martin Kim Dung-Pham on 08.12.19.
//
import Foundation

/// The `Subsystem` should be used as a subsystem of an `OSLog`
typealias Subsystem = String

extension Subsystem {
    static let baseSubsystem = "com.elbedev.books"

    static let keychainManager = baseSubsystem + ".keychain-manager"
    static let authenticationManager = .baseSubsystem + ".authentication-manager"
    static let defaults = .baseSubsystem + ".defaults"
}

/// The `Category` should be used as a category of an `OSLog`
typealias Category = String

extension Category {
    static let development: Category = "development"
}
