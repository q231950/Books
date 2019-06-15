//
//  Authentication.swift
//  
//
//  Created by Martin Kim Dung-Pham on 15.06.19.
//

import SwiftUI
import Combine

public class Authentication: BindableObject {

    public var authenticated: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }

    public init() {}

    public var didChange = PassthroughSubject<Authentication, Never>()
}

