import Foundation
import XCTest

public struct StubbornNetwork {
    public static var stubbedURLSession: StubbornURLSession {
        get {
            return URLSessionStub()
        }
    }
}

extension URLSession: StubbornURLSession {
    public func stub(_ request: URLRequest?, data: Data?, response: URLResponse?, error: Error?, into test: XCTestCase?) {
        // real URL sessions don't stub
    }
}

