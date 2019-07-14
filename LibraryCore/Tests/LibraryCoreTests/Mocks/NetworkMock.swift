//
//  NetworkMock.swift
//  LibraryCoreTests
//
//  Created by Martin Kim Dung-Pham on 25.08.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import XCTest
@testable import LibraryCore

class URLSessionDataTaskMock: URLSessionDataTask {
    var resumeCompletion: ((Data?, URLResponse?, Error?) -> Void)
    let data: Data?

    let stubbedResponse: URLResponse?
    override var response: URLResponse? {
        get {
            return stubbedResponse
        }
    }

    let stubbedError: Error?
    override var error: Error? {
        get {
            return stubbedError
        }
    }

    init(request: URLRequest, data: Data?, response: URLResponse?, error: Error?, resumeCompletion: @escaping (Data?, URLResponse?, Error?) -> Void) {

        self.resumeCompletion = resumeCompletion
        self.data = data
        self.stubbedResponse = response
        self.stubbedError = error
    }

    override func resume() {
        resumeCompletion(data, response, error)
    }
}

extension NetworkMock: Network {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        return URLSessionDataTaskMock(request: request,
                                      data: expectedDatas[request] ?? nil,
                                      response: expectedResponses[request] ?? nil,
                                      error:expectedErrors[request] ?? nil,
                                      resumeCompletion: completionHandler)
    }

    private func recordFailure(file: String = #file, line: Int = #line) {
        if let test = test {
            test.recordFailure(withDescription: "Received unexpected request.", inFile: file, atLine: line, expected: true)
        }
    }
}

enum NetworkMockError: Error {
    case unexpectedRequest(String)
}

class NetworkMock {

    var test: XCTestCase?
    var expectedDatas = [URLRequest: Data?]()
    var expectedResponses = [URLRequest: URLResponse?]()
    var expectedErrors = [URLRequest: Error?]()

    func stub(_ request: URLRequest? = URLRequest(url: URL(string: "127.0.0.1")!), data: Data? = nil, response: URLResponse? = nil, error: Error? = nil, into test: XCTestCase? = nil) {
        self.test = test
        if let request = request {
            if let data = data {
                expectedDatas[request] = data
            }

            if let response = response {
                expectedResponses[request] = response
            }
            if let error = error {
                expectedErrors[request] = error
            }
        }
    }

    private func acceptRequest(_ request:URLRequest) throws -> (Data?, URLResponse?, Error?) {
        if expectsRequest(request) {
            defer {
                expectedDatas[request] = nil
            }
            return (expectedDatas[request] ?? nil,
                    expectedResponses[request] ?? nil,
                    expectedErrors[request] ?? nil)
        } else {
            throw NetworkMockError.unexpectedRequest("Received unexpected request: [\(request.httpMethod!)] \(request.url!.absoluteString) Headers: \(request.allHTTPHeaderFields!)")
        }
    }

    private func expectsRequest(_ request: URLRequest) -> Bool {
        let expectedDataAvailable = expectedDatas.contains(where: request.matches())

        let expectedResponseAvailable = expectedResponses.contains(where: request.matches())

        let expectedErrorAvailable = expectedErrors.contains(where: request.matches())

        return expectedDataAvailable || expectedResponseAvailable || expectedErrorAvailable
    }
}

extension URLRequest {
    func matches<Value>() -> ((URLRequest, Value) -> Bool) {
        let closure = { (request: URLRequest, value: Value) -> Bool in
            return self.url == request.url &&
                self.httpMethod == request.httpMethod &&
                self.allHTTPHeaderFields == request.allHTTPHeaderFields
        }
        return closure
    }
}
