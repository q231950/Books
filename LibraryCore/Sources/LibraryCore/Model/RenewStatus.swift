//
//  RenewStatus.swift
//  
//
//  Created by Martin Kim Dung-Pham on 06.07.19.
//

import Foundation

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
