//
//  String+CurrencyConversionTests.swift
//  
//
//  Created by Martin Kim Dung-Pham on 07.07.19.
//

import XCTest
@testable import LibraryCore

class StringCurrencyConversionTests: XCTestCase {
    func testStringEuroValue() {
        XCTAssertEqual("€ 2,00".euroValue(), 2.0)
    }
}
