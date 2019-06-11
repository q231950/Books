//
//  PublicLibraryScraper.swift
//  books
//
//  Created by Martin Kim Dung-Pham on 01/09/14.
//  Copyright (c) 2014 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation

typealias SessionIdentifier = String

enum ValidationStatus: Equatable {
    case valid
    case invalid
    case error(NSError)
}

enum RenewStatus: Equatable {
    case success(String)
    case failure
    case error(Error)

    static func == (lhs: RenewStatus, rhs: RenewStatus) -> Bool {
        switch (lhs, rhs) {
        case let (.success(a), .success(b)): return a == b
        case (.failure, .failure): return true
        case let (.error(e1), .error(e2)): return e1.localizedDescription == e2.localizedDescription
        default: return false
        }
    }
}

internal final class PublicLibraryScraper {

    private let network: Network
    private let keychainProvider: KeychainProvider
    private let baseUrlString = "https://www.buecherhallen.de"

    static func accountScraperWithDefaultNetwork() -> PublicLibraryScraper {
        return PublicLibraryScraper()
    }

    init(network: Network = NetworkClient(), keychainProvider: KeychainProvider = KeychainManager()) {
        self.network = network
        self.keychainProvider = keychainProvider
    }
}
