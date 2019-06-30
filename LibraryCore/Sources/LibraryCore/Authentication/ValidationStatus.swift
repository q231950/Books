//
//  AuthenticationValidationStatus.swift
//  books
//
//  Created by Martin Kim Dung-Pham on 01/09/14.
//  Copyright (c) 2014 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation

enum AuthenticationValidationStatus: Equatable {
    case valid
    case invalid
    case error(NSError)
}
