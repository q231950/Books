//
//  Loan.swift
//  
//
//  Created by Martin Kim Dung-Pham on 06.07.19.
//

import Combine
import Foundation

public struct Loan {
    public var identifier: String?  {
        didSet { passthroughSubject.send(self) }
    }
    public var expiryDate: String? {
        didSet { passthroughSubject.send(self) }
    }
    public var signature: String?  {
        didSet { passthroughSubject.send(self) }
    }
    public var author: String? {
        didSet { passthroughSubject.send(self) }
    }
    public var title: String? {
        didSet { passthroughSubject.send(self) }
    }

    public var barcode: String? {
        didSet { passthroughSubject.send(self) }
    }

    public let passthroughSubject = PassthroughSubject<Loan, Never>()

    public init(expiryDate: Date?) {
        if let expiryDate = expiryDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.expiryDate = dateFormatter.string(from: expiryDate)
        }
    }
}
