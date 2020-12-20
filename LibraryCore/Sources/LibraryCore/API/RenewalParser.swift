//
//  RenewalParser.swift
//  BTLB
//
//  Created by Martin Kim Dung-Pham on 26.08.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation
import AEXML

class RenewalParser {

    /// *@return* the renew status after submitting a renew request to the library
    func isRenewed(data: Data?) -> RenewStatus {
        guard let data = data else {
            return .error(NSError(domain: "com.elbedev.sync.RenewalParser", code: 2))
        }

        do {
            let xml = try AEXMLDocument(xml: data)
            let hasRenewalError = xml.root["soap:Body"]["RenewItemResponse"]["RenewItemResult"]["record"]["RenewItemResult"]["ItemError"].int ?? 0

            if hasRenewalError > 0 {
                return .failure
            }

            let dueDate = xml.root["soap:Body"]["RenewItemResponse"]["RenewItemResult"]["record"]["RenewItemResult"]["ItemNewDueDate"].string

            if dueDate.count > 0 {
                return .success(dueDate)
            }

            return .error(NSError(domain: "com.elbedev.sync.RenewalParser", code: 2))
        } catch let err {
            return .error(err)
        }
    }
}
