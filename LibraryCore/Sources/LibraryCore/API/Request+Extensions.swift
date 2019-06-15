//
//  Request+Extensions.swift
//  biblib
//
//  Created by Martin Kim Dung-Pham on 11.05.15.
//  Copyright (c) 2015 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation

let baseUrlString = "www.buecherhallen.de"

extension URLRequest {
    
    static func request(method: String, host: String = baseUrlString, path: String, body: Data? = nil, parameters: [String: AnyHashable] = [:], headers: [String: String] = [:]) -> URLRequest? {
        var request: URLRequest?
        
        if let url = URL(string: "https://\(host)/")?.appendingPathComponent(path) {
            request = URLRequest(url: url)
            request?.httpMethod = method
            headers.forEach { (key, value) in
                request?.addValue("\(value)", forHTTPHeaderField: key)
            }
            let parameterStrings = parameters.compactMap { (key: String, value: AnyHashable) -> String in
                return "\(key)=\(value)"
            }
            if let body = body {
                request?.httpBody = body
            } else {
                let postString = parameterStrings.joined(separator: "&")
                request?.httpBody = postString.data(using: .utf8)
            }
        }
        
        return request as URLRequest?
    }
}
