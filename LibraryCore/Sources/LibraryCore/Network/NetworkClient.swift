//
//  NetworkClient.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 25.08.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation
#if DEBUG
import StubbornNetwork
#endif

public class NetworkClient {

    let session: URLSession

    static var shared = NetworkClient()

    public init(session: URLSession? = nil) {
        if let session = session {
            self.session = session
        } else {
            let session: URLSession
            if ProcessInfo().isUITesting {
                let stubbedSession = StubbornNetwork.makePersistentSession()
                stubbedSession.recordMode = .playback
                session = stubbedSession
            } else {
                let configuration = URLSessionConfiguration.default
                configuration.httpCookieStorage?.cookieAcceptPolicy = .always
                session = URLSession(configuration: configuration)
            }

            self.session = session
        }
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: completionHandler)
    }

}
