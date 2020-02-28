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

public class LoanViewModel: ObservableObject, Hashable {

    public static func == (lhs: LoanViewModel, rhs: LoanViewModel) -> Bool {
        return lhs.loan?.signature == rhs.loan?.signature
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(loan?.signature)
    }

    public var loan: FlamingoLoan? {
        didSet {
            self.didChange.send(self)
        }
    }

    public var didChange = PassthroughSubject<LoanViewModel, Never>()

    var identifier: String? {
        loan?.signature
    }

    init(loan: FlamingoLoan) {
        self.loan = loan
    }

}
