//
//  Coordinator.swift
//  Books
//
//  Created by Kim Dung-Pham on 02.01.21.
//  Copyright © 2021 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation

protocol Controlling {
    associatedtype ViewModel

    var viewModel: ViewModel { get }
}

struct Coordinator<Controlling, Interactor> {
    let controller: Controlling
    let interactor: Interactor
}
