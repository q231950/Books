//
//  URLSessionStub.swift
//  
//
//  Created by Martin Kim Dung-Pham on 14.07.19.
//

import Foundation
import XCTest

public protocol StubbornURLSession {
    func stub(_ request: URLRequest?, data: Data?, response: URLResponse?, error: Error?, into test: XCTestCase?)

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

enum NetworkMockError: Error {
    case unexpectedRequest(String)
}

class URLSessionStub {
    var test: XCTestCase?
    var expectedDatas = [URLRequest: Data?]()
    var expectedResponses = [URLRequest: URLResponse?]()
    var expectedErrors = [URLRequest: Error?]()

    // add an init with a name or

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

extension URLSessionStub: StubbornURLSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock(request: request,
                                      data: expectedDatas[request] ?? nil,
                                      response: expectedResponses[request] ?? nil,
                                      error:expectedErrors[request] ?? nil,
                                      resumeCompletion: completionHandler)
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        return dataTask(with: request, completionHandler: completionHandler)
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
