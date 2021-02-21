import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(LibraryCoreTests.allTests),
    ]
}
#endif
