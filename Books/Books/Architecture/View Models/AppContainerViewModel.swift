//
//  AppContainerViewModel.swift
//  Books
//
//  Created by Kim Dung-Pham on 02.01.21.
//  Copyright © 2021 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation
import Combine
import LibraryCore

class AppContainerViewModel: ObservableObject {

    @Published var appState: AppState
    @Published var authenticationState: AuthenticationState

    private var disposeBag = Set<AnyCancellable>()

    init() {
        let appStatePublisher = AppEnvironment.current.appStatePublisher
        appState = appStatePublisher.value

        let authenticationStatePublisher = AppEnvironment.current.authenticationStatePublisher
        authenticationState = authenticationStatePublisher.value

        appStatePublisher
            .receive(on: RunLoop.main)
            .sink { self.appState = $0 }
            .store(in: &disposeBag)

        authenticationStatePublisher
            .receive(on: RunLoop.main)
            .sink { self.authenticationState = $0 }
            .store(in: &disposeBag)
    }
}
