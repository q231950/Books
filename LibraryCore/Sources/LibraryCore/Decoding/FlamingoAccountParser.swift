//
//  FlamingoAccount.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 25.08.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation
import AEXML

class FlamingoCharge: Equatable {

    let reason: String
    let debit: Float
    let credit: Float
    let date: Date?

    init(reason: String, date: Date?, debit: Float, credit: Float) {
        self.reason = reason
        self.date = date
        self.debit = debit
        self.credit = credit
    }

    static func ==(lhs: FlamingoCharge, rhs: FlamingoCharge) -> Bool {
        return lhs.reason == rhs.reason &&
            lhs.date == rhs.date &&
            lhs.debit == rhs.debit &&
            lhs.credit == rhs.credit
    }

    var debugDescription: String {
        let dateString = AccountParser.dateReaderFormatter.string(from: date ?? Date())
        return "Reason: \(reason) (\(dateString)) - Debit: \(debit), Credit: \(credit)"
    }
}

class FlamingoAccount {

    let name: String
    let identifier: String
    let email: String
    let charges: [FlamingoCharge]

    init?(identifier: String?, name: String?, email: String?, charges: [FlamingoCharge] = []) {
        guard let identifier = identifier,
            let name = name, let email = email else {
                return nil
        }

        self.identifier = identifier
        self.name = name
        self.email = email
        self.charges = charges
    }
}

class AccountParser {

    fileprivate static var dateReaderFormatter: DateFormatter = {
        let dateReaderFormatter = DateFormatter()
        dateReaderFormatter.dateFormat = "dd/M/yyyy"
        dateReaderFormatter.timeZone = TimeZone(identifier: "Europe/Berlin")
        return dateReaderFormatter
    }()

    func account(data: Data?) -> FlamingoAccount? {
        guard let data = data else {
            return nil
        }

        do {
            let xml = try AEXMLDocument(xml: data)
            let accountElement = xml.root["soap:Body"]["GetBorrowerAccountResponse"]["GetBorrowerAccountResult"]
            let identifier = accountElement["userId"].string

            let accountDetails = accountElement["record"]["GetBorrowerAccountResult"]["AccountDetails"].children

            let email: String = ""
            let name: String = ""

            let charges = chargesForAccountDetails(accountDetails)
            return FlamingoAccount(identifier: identifier, name: name, email: email, charges: charges)
        }
        catch _ {
            return nil
        }
    }

    func chargesForAccountDetails(_ elements: [AEXMLElement]) -> [FlamingoCharge] {

        var charges = [FlamingoCharge]()

        elements.forEach({ child in
            let reason = child["TransactionIDName"].string

            let debit = child["Debit"].string.euroValue()
            let credit = child["Credit"].string.euroValue()
            let dateString = child["Created"].string
            let date = AccountParser.dateReaderFormatter.date(from: dateString)
            let charge = FlamingoCharge(reason: reason, date: date, debit: debit, credit: credit)
            charges.append(charge)
        })
        return charges
    }

}
