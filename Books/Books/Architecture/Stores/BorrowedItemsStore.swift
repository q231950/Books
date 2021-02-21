//
//  BorrowedItemsStore.swift
//  Books
//
//  Created by Kim Dung-Pham on 17.01.21.
//  Copyright © 2021 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation
import Combine
import LibraryCore

class BorrowedItemsStore {

    let items = CurrentValueSubject<[FlamingoLoan], Never>([])
    private var disposeBag = [AnyCancellable]()

    init(authenticationStatePublisher: AuthenticationStateSubject, authenticationManager: AuthenticationManager) {

        authenticationStatePublisher.sink { [weak self] state in
            self?.items.send([])

            switch state {
            case .authenticationComplete(.authenticated(let credentials)):
                let apiClient = APIClient.shared
                apiClient.loans(credentials, authenticationManager: authenticationManager, completion: { (error, loans) -> (Void) in
                    DispatchQueue.main.async {
                                            self?.items.send(loans)
                    }
                })
                break
            default:
                break
            }
        }
        .store(in: &disposeBag)
    }
}
