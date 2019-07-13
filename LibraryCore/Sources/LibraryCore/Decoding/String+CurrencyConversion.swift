//
//  String+CurrencyConversion.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 14.10.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation

extension String {

    func euroValue() -> Float {
        let withoutCurrencySymbol = self.trimmingCharacters(in: CharacterSet(charactersIn: "€ "))

        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "de_DE")

        guard let number = numberFormatter.number(from: withoutCurrencySymbol) else {
            return 0
        }

        return number.floatValue
    }
}
