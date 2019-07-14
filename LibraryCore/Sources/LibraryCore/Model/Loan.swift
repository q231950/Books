//
//  Loan.swift
//  
//
//  Created by Martin Kim Dung-Pham on 06.07.19.
//

import Combine

public struct Loan {
    public var identifier: String?  {
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

    public let passthroughSubject = PassthroughSubject<Loan, Never>()

    public init() {

    }
}
