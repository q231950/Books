//
//  PublicLibraryScraper.swift
//  books
//
//  Created by Martin Kim Dung-Pham on 01/09/14.
//  Copyright (c) 2014 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation

public typealias SessionIdentifier = String

public final class PublicLibraryScraper {

    private let network: NetworkClient
    private let keychainProvider: KeychainProvider
    private let baseUrlString = "https://www.buecherhallen.de"
    var authenticationSink: Any?

    public static var `default`: PublicLibraryScraper {
        get {
            return PublicLibraryScraper()
        }
    }

    init(network: NetworkClient = NetworkClient.shared, keychainProvider: KeychainProvider = KeychainManager()) {
        self.network = network
        self.keychainProvider = keychainProvider
    }
    
    // MARK: Account
    
    public func profile(_ account: AccountModel, completion:((_ error:Error?) -> Void)!) {
        // profile is currently not fetched
        completion(nil)
    }

    // MARK: Charges

    func charges(account: AccountModel, sessionIdentifier: SessionIdentifier, completion:@escaping ((_ error: Error?, _ charges: [Charge]) -> (Void))) {

        guard let request = RequestBuilder.default.accountRequest(sessionIdentifier: sessionIdentifier) else {
            completion(NSError(domain: "\(type(of: self))", code: 1, userInfo: nil), [])
            return
        }

        let task = network.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(error, [])
                return
            }

            var charges = [Charge]()
            let parser = AccountParser()
            parser.account(data: data)?.charges.compactMap({ (flamingoCharge) -> Charge? in
                let amount = NSDecimalNumber(floatLiteral: Double(flamingoCharge.debit - flamingoCharge.credit))
                let charge = Charge(amount: amount, reason: flamingoCharge.reason, date: flamingoCharge.date, endDate: nil)
                return charge
            }).forEach({ (charge) in
                charges.append(charge)
            })
            completion(nil, charges)
        }
        task.resume()
    }

    // MARK: Loans

    public func loans(_ account: AccountModel, authenticationManager: AuthenticationManager, completion:@escaping ((_ error:Error?, _ loans: [Loan])->(Void))) {

        guard let sessionIdentifier = authenticationManager.sessionIdentifier(for: account.username) else {
            return
        }

        var loans = [Loan]()

        guard let req = RequestBuilder.default.loansRequest(sessionIdentifier: sessionIdentifier),
            let baseUrl = URL(string: baseUrlString) else {
                completion(NSError(domain: "\(type(of: self))", code: 3, userInfo: nil), loans)
                return
        }

        let finishedCompletion = { (count: Int, loans: [Loan]) -> Void in
            guard count == 0 else {
                return
            }
            completion(nil, loans)
        }

        let task = self.network.dataTask(with: req, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(error, loans)
                return
            }

            let parser = FlamingoLoansParser(baseUrl: baseUrl)
            let minimalFlamingoLoans = parser.loans(data: data)
            var numberOfLoansToProcess = minimalFlamingoLoans.count
            if numberOfLoansToProcess == 0 {
                finishedCompletion(numberOfLoansToProcess, loans)
            }
            minimalFlamingoLoans.forEach({ (minimalLoan) in
                if let signature = minimalLoan.signature {
                    var loan = Loan(expiryDate: minimalLoan.expiryDate)
                    loan.identifier = signature
                    self.detailedLoan(loan: loan) { (author, title, signature) in
                        loan.author = author
                        loan.title = title
                        loan.signature = signature
                        loan.barcode = minimalLoan.barcode
                        loans.append(loan)
                        numberOfLoansToProcess -= 1
                        finishedCompletion(numberOfLoansToProcess, loans)
                    }
                } else {
                    completion(NSError(domain: "\(type(of: self))", code: 4, userInfo: nil), loans)
                }
            })
        })
        task.resume()
    }

    private func detailedLoan(loan: Loan, completion: @escaping (String, String, String) -> Void ) {
        guard let identifier = loan.identifier, let request = RequestBuilder.default.itemDetailsRequest(itemIdentifier: identifier) else {
            defer {
                completion("", "", "")
            }
            return
        }

        let task = network.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            let parser = ItemDetailsParser()
            let infoPairs = parser.searchResultDetails(for: data)
            var author = ""
            var title = ""
            var signature = identifier
            infoPairs.forEach({ (keyValuePair) in
                let infoPair = keyValuePair
                if infoPair.title == "Author" {
                    author = infoPair.content
                } else if infoPair.title == "data titel-lang" {
                    title = infoPair.content
                } else if infoPair.title == "data signatur" {
                    signature = infoPair.content
                }
            })
            completion(author, title, signature)
        })
        task.resume()
    }

    // MARK: Renewal

    public func renew(account: AccountModel, accountStore: AccountStoring, itemIdentifier: String, completion:@escaping ((_ renewState: RenewStatus) -> Void)) {

        let credentialStore = AccountCredentialStore(keychainProvider: keychainProvider)
        let authenticationManager = AuthenticationManager(network: network,
                                                          credentialStore: credentialStore,
                                                          accountStore: accountStore)
        authenticationSink = authenticationManager.authenticatedSubject
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let authenticationError): ()
                case .finished: ()
                }
            }, receiveValue: { authenticated in
                guard let token = authenticationManager.sessionIdentifier(for: account.username) else {
                    completion(.error(NSError(domain: "com.elbedev.sync.PublicLibraryAccountScraper.renew", code: 1)))
                    return
                }

                guard let request = RequestBuilder.default.renewRequest(
                    sessionIdentifier: token,
                    itemIdentifier: itemIdentifier) else {
                        completion(.error(NSError(domain: "com.elbedev.sync.PublicLibraryAccountScraper.renew", code: 2)))
                        return
                }

                let task = self.network.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    guard error == nil else {
                        completion(.error(NSError(domain: "com.elbedev.sync.PublicLibraryAccountScraper.renew", code: 3)))
                        return
                    }

                    let renewalParser = RenewalParser()
                    completion(renewalParser.isRenewed(data: data))
                })
                task.resume()
        })
        authenticationManager.authenticateAccount(username: account.username, password: account.password)
    }

}
