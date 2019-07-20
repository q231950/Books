import XCTest
@testable import StubbornNetwork

final class StubbornNetworkTests: XCTestCase {
    func testStubbedURLSessionNotNil() {
        XCTAssertNotNil(StubbornNetwork.stubbedURLSession)
    }

    static var allTests = [
        ("testExample", testStubbedURLSessionNotNil),
    ]
}
