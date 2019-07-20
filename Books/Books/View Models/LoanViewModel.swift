//
//  LoanViewModel.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 13.07.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import Combine
import LibraryCore

public class LoanViewModel: BindableObject, Hashable {

    public var willChange = PassthroughSubject<LoanViewModel, Never>()
    public var didChange = PassthroughSubject<LoanViewModel, Never>()

    public static func == (lhs: LoanViewModel, rhs: LoanViewModel) -> Bool {
        return lhs.loan?.signature == rhs.loan?.signature
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(loan?.signature)
    }

    public var loan: Loan? {
        willSet {
                    DispatchQueue.main.async {
                        self.willChange.send(self)
                    }
                }
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }

    init(loan: Loan) {
        self.loan = loan
    }

}
