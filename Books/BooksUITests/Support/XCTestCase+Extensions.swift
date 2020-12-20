//
//  XCTestCase+Extensions.swift
//  BooksUITests
//
//  Created by Martin Kim Dung-Pham on 12.11.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import XCTest

extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        XCTAssertTrue(element.waitForExistence(timeout: timeout))
    }
}
