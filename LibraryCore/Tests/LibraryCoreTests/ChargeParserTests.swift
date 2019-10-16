//
//  ChargeParserTests.swift
//  
//
//  Created by Martin Kim Dung-Pham on 07.07.19.
//

import XCTest
@testable import LibraryCore

class ChargeTests: XCTestCase {
    func testChargeDebugDescription() {
        let dateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(identifier: "Europe/Berlin"), year: 2018, month: 9, day: 20)
        let charge = FlamingoCharge(reason: "Vormerkgebühr", date: dateComponents.date, debit: 2.0, credit: 1.0)
        XCTAssertEqual(charge.debugDescription, "Reason: Vormerkgebühr (20/9/2018) - Debit: 2.0, Credit: 1.0")
    }
}
