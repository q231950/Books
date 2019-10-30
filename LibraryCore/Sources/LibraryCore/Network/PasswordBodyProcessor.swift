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
        var processed = text.replacingOccurrences(of: "<pin>(.*)</pin>", with: "<pin>***</pin>", options: [.caseInsensitive, .regularExpression])
        processed = processed.replacingOccurrences(of: "<Brwr>((.|\n)*)</Brwr>", with: "<Brwr>A12 345 678 9</Brwr>", options: [.caseInsensitive, .regularExpression])
        processed = processed.replacingOccurrences(of: "<borrowerNumber>(.*)</borrowerNumber>", with: "<borrowerNumber>123456789</borrowerNumber>", options: [.caseInsensitive, .regularExpression])
        processed = processed.replacingOccurrences(of: "<userId>(.*)</userId>", with: "<userId>123456789</userId>", options: [.regularExpression])
        processed = processed.replacingOccurrences(of: "<UserId>(.*)</UserId>", with: "<UserId>12345</UserId>", options: [.regularExpression])
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
