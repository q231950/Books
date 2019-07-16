import XCTest
@testable import StubbornNetwork

final class StubbornNetworkTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(StubbornNetwork().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
