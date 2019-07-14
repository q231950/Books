//
//  FlamingoLoansParser.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 25.08.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation
import AEXML

class FlamingoLoan {
    var signature: String?
    var barcode: String?
    var expiryDate: Date?
    var borrowedDate: Date?
    var timesProlonged = 0
    var status: String?
    var author: String?
    var title: String?
    var detailsUrl: URL?
    var renewUrl: URL?
    var isLoaned = false
    var infos = [String:String]()

    func addInfo(title: String, content: String) {
        infos[title] = content
    }

}

class FlamingoLoansParser {

    let dateFormatter = DateFormatter()
    let baseUrl: URL

    init(baseUrl: URL) {
        self.baseUrl = baseUrl
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: -3600)
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
        loan.author = element["Author"].string
        loan.title = element["Title"].string
        loan.detailsUrl = detailsUrl(for: element)
        loan.timesProlonged = element["RenewalCount"].int ?? 0
        if let date = dateFormatter.date(from: element["DateDue"].string) {
            loan.expiryDate = date
        }
        if let date = dateFormatter.date(from: element["DateIssued"].string) {
            loan.borrowedDate = date
        }
        loan.barcode = element["ItemNumber"].string
        loan.signature = element["BacNo"].string

        let author = element["Author"].string
        if author.count > 0 {
            loan.addInfo(title: "Author", content: author)
        }

        let isbn = element["ISBN"].string
        if isbn.count > 0 {
            loan.addInfo(title: "data isbn-ean", content: isbn)
        }


        return loan
    }

}
