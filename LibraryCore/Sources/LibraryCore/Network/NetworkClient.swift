//
//  NetworkClient.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 25.08.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation
import StubbornNetwork

public class NetworkClient {

    let session: URLSession

    static var shared = NetworkClient()

    public init(session: URLSession? = nil) {
        if let session = session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.httpCookieStorage?.cookieAcceptPolicy = .always

            if ProcessInfo().isUITesting {
                #if DEBUG
                StubbornNetwork.standard.insertStubbedSessionURLProtocol(into: configuration)
                StubbornNetwork.standard.bodyDataProcessor = SensitiveDataProcessor()
                #endif
            }

            self.session = URLSession(configuration: configuration)
        }
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: completionHandler)
    }

}
