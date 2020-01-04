//
//  OSLog+Utilities.swift
//  
//
//  Created by Martin Kim Dung-Pham on 08.12.19.
//
import Foundation

/// The `Subsystem` should be used as a subsystem of an `OSLog`
public typealias Subsystem = String

public extension Subsystem {
    static let baseSubsystem = "com.elbedev.books"

    static let libraryCore = .baseSubsystem + ".library-core"
    static let keychainManager = baseSubsystem + ".keychain-manager"
    static let authenticationManager = .baseSubsystem + ".authentication-manager"
    static let accountStore = .baseSubsystem + ".account-store"
}

/// The `Category` should be used as a category of an `OSLog`
public typealias Category = String

public extension Category {
    static let development: Category = "development"
}
