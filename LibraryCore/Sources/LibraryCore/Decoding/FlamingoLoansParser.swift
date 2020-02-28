//
//  FlamingoLoansParser.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 25.08.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation
import AEXML

public class FlamingoLoan: ObservableObject {

    public static func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: -3600)
        return dateFormatter
    }

    @Published public var identifier: String?
    @Published public var signature: String?
    @Published public var barcode: String?
    @Published public var expiryDate: Date? {
        didSet {
            if let date = expiryDate {
                let dateFormatter = FlamingoLoan.dateFormatter()
                expiryDateString = dateFormatter.string(from: date)
            }
        }
    }
    @Published public var expiryDateString: String?
    @Published public var borrowedDate: Date? {
        didSet {
            if let date = borrowedDate {
                let dateFormatter = FlamingoLoan.dateFormatter()
                dateIssuedString = dateFormatter.string(from: date)
            }
        }
    }
    @Published public var timesProlonged = 0
    @Published public var status: String?
    @Published public var author: String?
    @Published public var title: String?
    @Published public var interestLevelName: String?
    @Published public var locationIssued: String?
    @Published public var locationIssuedName: String?
    @Published public var publishedYear: String?
    @Published public var owner: String?
    @Published public var price: String?
    @Published public var language: String?
    @Published public var detailsUrl: URL?
    @Published public var isLoaned = false
    @Published public var recNo: String?
    @Published public var bacNo: String?
    @Published public var isbn: String?
    @Published public var ean: String?
    @Published public var dateIssuedString: String?
    @Published public var issuedToday: String?
    @Published public var overdue = false
    @Published public var renewable = false
    @Published public var renewalCount = 0
    @Published public var renewedToday = false
    @Published public var renewalDate: Date? {
        didSet {
            if let date = renewalDate, date != borrowedDate {
                let dateFormatter = FlamingoLoan.dateFormatter()
                renewalDateString = dateFormatter.string(from: date)
            }
        }
    }
    @Published public var renewalDateString: String?
    @Published public var renewalFee: String?
    @Published public var recalled = false
    @Published public var material: String?
    @Published public var materialName: String?
    @Published public var isReserved = false
    @Published public var primaryTrapIdText: String?
    @Published public var primaryTrapLevelText: String?

    public init() {
    }
}

enum ElementKey {
    static let author = "Author"
    static let title = "Title"
    static let recNo = "RecNo"
    static let bacNo = "BacNo"
    static let isbn = "ISBN"
    static let ean = "EAN"
    static let dateDue = "DateDue"
    static let dateIssued = "DateIssued"
    static let issuedToday = "IssuedToday"
    static let dueToday = "DueToday"
    static let overdue = "Overdue"
    static let recalled = "Recalled"
    static let renewalCount = "RenewalCount"
    static let renewalFee = "RenewalFee"
    static let dateRenewed = "DateRenewed"
    static let renewedToday = "RenewedToday"
    static let locationIssued = "LocationIssued"
    static let locationIssuedName = "LocationIssuedText"
    static let itemNumber = "ItemNumber"
    static let material = "Material"
    static let materialName = "MaterialName"
    static let isReserved = "IsReserved"
    static let primaryTrapId = "PrimaryTrapId"
    static let primaryTrapIdText = "PrimaryTrapIdText"
    static let primaryTrapLevel = "PrimaryTrapLevel"
    static let primaryTrapLevelText = "PrimaryTrapLevelText"
    static let fine = "Fine"
    static let sip2 = "SIP2"
    static let canRenew = "CanRenew"
}

class FlamingoLoansParser {

    let dateFormatter = FlamingoLoan.dateFormatter()
    let baseUrl: URL

    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }

    func loans(data: Data?) -> [FlamingoLoan] {

        guard let data = data else {
            return []
        }

        var loans = [FlamingoLoan]()

        do {
            let xml = try AEXMLDocument(xml: data)
            let loansBlock = xml.root["soap:Body"]["GetBorrowerLoansResponse"]["GetBorrowerLoansResult"]["record"]["GetBorrowerLoansResult"]["LoanDetails"].children
            for child: AEXMLElement in loansBlock {
                let flamingoLoan = loanFromElement(element: child)
                loans.append(flamingoLoan)
            }


            return loans
        } catch _ {
            return []
        }
    }

    private func detailsUrl(for element: AEXMLElement) -> URL? {
        let identifier = element["BacNo"].string
        if identifier.count > 0 {
            return baseUrl.appendingPathComponent("suchergebnis-detail/medium/\(identifier).html")
        }
        return nil
    }

    /// - returns: Creates a `FlamingoLoan` from the given xml element
    /// - parameter element: The xml element that serves as the data source for the loan's information
    private func loanFromElement(element: AEXMLElement) -> FlamingoLoan {
        let loan = FlamingoLoan()
        loan.isLoaned = true
        loan.author = element[ElementKey.author].string
        loan.title = element[ElementKey.title].string
        loan.detailsUrl = detailsUrl(for: element)
        loan.timesProlonged = element[ElementKey.renewalCount].int ?? 0
        if let date = dateFormatter.date(from: element[ElementKey.dateDue].string) {
            loan.expiryDate = date
        }
        if let date = dateFormatter.date(from: element[ElementKey.dateIssued].string) {
            loan.borrowedDate = date
        }
        loan.barcode = element[ElementKey.itemNumber].string
        loan.identifier = element[ElementKey.bacNo].string

        let material = element[ElementKey.material]
        if material.count > 0 {
            loan.material = material.string
        }

        let isbn = element[ElementKey.isbn]
        if isbn.count > 0 {
            loan.isbn = isbn.string
        }

        let overdue = element[ElementKey.overdue]
        loan.overdue = overdue.string == "1"

        let locationIssuedName = element[ElementKey.locationIssuedName]
        if locationIssuedName.count > 0 {
            loan.locationIssuedName = locationIssuedName.string
        }

        let sip2 = element[ElementKey.sip2]
        let renewable = sip2[ElementKey.canRenew]
        loan.renewable = renewable.string == "1"

        let renewalDate = element[ElementKey.dateRenewed]
        if renewalDate.count > 0 {
            loan.renewalDate = dateFormatter.date(from: renewalDate.string)
        }

        return loan
    }

}
