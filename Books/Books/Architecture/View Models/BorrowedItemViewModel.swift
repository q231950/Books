//
//  BorrowedItemViewModel.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 13.07.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import Combine
import LibraryCore

public class BorrowedItemViewModel: ObservableObject, Hashable {

    enum RenewalState {
        case idle, renewing, renewed, error
    }

    @Published var renewalState: BorrowedItemViewModel.RenewalState = .idle
    @Published public var loan: FlamingoLoan?

    var identifier: String? {
        loan?.identifier
    }

    private var disposeBag = [AnyCancellable]()

    init(loan: FlamingoLoan) {
        self.loan = loan

        AppEnvironment.current.borrowedItemInteractor.renewalPublisher.sink { [weak self] state in
            if let newState = state.viewModelState(identifier: self?.identifier) {
                self?.renewalState = newState
            }
        }
        .store(in: &disposeBag)
    }

    public static func == (lhs: BorrowedItemViewModel, rhs: BorrowedItemViewModel) -> Bool {
        lhs.loan?.signature == rhs.loan?.signature
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(loan?.signature)
    }

}

extension RenewalState {
    func viewModelState(identifier: String?) -> BorrowedItemViewModel.RenewalState? {

        var state: BorrowedItemViewModel.RenewalState?

        switch self {
        case .idle(let renewedIdentifier):
            if renewedIdentifier == identifier { state = .idle }
        case .error(let renewedIdentifier):
            if renewedIdentifier == identifier { state = .error }
        case .renewing(let renewedIdentifier):
            if renewedIdentifier == identifier { state = .renewing }
        case .renewed(let renewedIdentifier):
            if renewedIdentifier == identifier { state = .renewed }
        }

        return state
    }
}
