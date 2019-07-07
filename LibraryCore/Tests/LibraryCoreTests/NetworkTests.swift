//
//  NetworkTests.swift
//  
//
//  Created by Martin Kim Dung-Pham on 07.07.19.
//

import XCTest
@testable import LibraryCore

class NetworkTests: XCTestCase {

    let network = NetworkClient()

    func testNetwork() {
        XCTAssertNotNil(network.session)
    }

    func testNetworkReturnsSuspendenDataTasks() {
        let url = URL(string: "127.0.0.1")
        let urlRequest = URLRequest(url: url!)
        let task = network.dataTask(with: urlRequest) { (data, response, error) in }
        XCTAssertEqual(task.state, URLSessionTask.State.suspended)
    }
}
