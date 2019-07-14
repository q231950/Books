//
//  Network.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 25.08.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation

protocol Network: AnyObject {

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

}

class NetworkClient: Network {

    let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpCookieStorage?.cookieAcceptPolicy = .always
        session = URLSession(configuration: configuration)
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: completionHandler)
    }

}
