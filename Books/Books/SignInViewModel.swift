//
//  SignInViewModel.swift
//  Books
//
//  Created by Kim Dung-Pham on 02.01.21.
//  Copyright © 2021 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation
import LibraryCore
import Combine

class SignInViewModel: ObservableObject, CredentialsProvider {
    var credentialsPublisher = PassthroughSubject<Credentials, Never>()

}
