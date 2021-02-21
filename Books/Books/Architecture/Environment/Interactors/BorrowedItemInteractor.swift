//
//  BorrowedItemInteractor.swift
//  Books
//
//  Created by Kim Dung-Pham on 16.01.21.
//  Copyright © 2021 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation
import LibraryCore
import Combine

enum RenewalState {
    case idle(identifier: String), renewing(identifier: String), renewed(identifier: String), error(identifier: String)
}

class BorrowedItemInteractor {

    let renewalPublisher = PassthroughSubject<RenewalState, Never>()
    private var credentials = Credentials()
    private let accountStore: AccountStore
    private var disposeBag = [AnyCancellable]()

    init(authenticationStatePublisher: AuthenticationStateSubject, accountStore: AccountStore) {

        self.accountStore = accountStore

        authenticationStatePublisher.sink { [weak self] state in
            switch state {
            case .authenticationComplete(.authenticated(credentials: let credentials)):
                self?.credentials = credentials
            default:
                break
            }
        }
        .store(in: &disposeBag)
    }

    func renew(identifier: String?) {
        guard let identifier = identifier else { return }
        renewalPublisher.send(.renewing(identifier: identifier))

        APIClient.shared.renew(credentials: credentials,
                               accountStore: accountStore,
                               itemIdentifier: identifier) { [weak self] renewStatus in
            switch renewStatus {
            case .success:
                self?.renewalPublisher.send(.renewed(identifier: identifier))
            case .error:
                self?.renewalPublisher.send(.error(identifier: identifier))
            default: break
            }
        }

    }
}
