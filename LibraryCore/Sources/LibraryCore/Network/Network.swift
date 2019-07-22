//
//  Network.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 25.08.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation
import StubbornNetwork

public class NetworkClient {

    let session: URLSession

    public init(session: URLSession? = nil) {
        if let session = session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.httpCookieStorage?.cookieAcceptPolicy = .always
            self.session = URLSession(configuration: configuration)
        }
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: completionHandler)
    }

}
