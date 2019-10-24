//
//  PassworkBodyProcessor.swift
//
//
//  Created by Martin Kim Dung-Pham on 19.10.19.
//

import Foundation
import StubbornNetwork

struct PasswordBodyProcessor: BodyDataProcessor {
    func textByStrippingSensitiveData(from text: String) -> String {
        let processed = text.replacingOccurrences(of: "<pin>(.*)</pin>", with: "<pin>***</pin>", options: [.caseInsensitive, .regularExpression])
        return processed
    }

    func dataForStoringRequestBody(data: Data?, of request: URLRequest) -> Data? {
        guard let unwrappedData = data, let dataAsString = String(data: unwrappedData, encoding: .utf8) else {
            return data
        }
        return textByStrippingSensitiveData(from: dataAsString).data(using: .utf8)
    }

    func dataForStoringResponseBody(data: Data?, of request: URLRequest) -> Data? {
        guard let unwrappedData = data, let dataAsString = String(data: unwrappedData, encoding: .utf8) else {
            return data
        }
        return textByStrippingSensitiveData(from: dataAsString).data(using: .utf8)
    }

    func dataForDeliveringResponseBody(data: Data?, of request: URLRequest) -> Data? {
        return data
    }

}
