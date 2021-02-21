//
//  APIClient.swift
//  books
//
//  Created by Martin Kim Dung-Pham on 01/09/14.
//  Copyright (c) 2014 Martin Kim Dung-Pham. All rights reserved.
//

import Foundation
import os
import Combine
import XMLCoder

public typealias SessionIdentifier = String

public final class APIClient {

    private let network: NetworkClient
    private let keychainProvider: KeychainProvider
    private let baseUrlString = "https://www.buecherhallen.de"
    private let log = OSLog(subsystem: .development, category: .scraper)

    var disposeBag = Set<AnyCancellable>()

    public static var shared: APIClient = {
        APIClient()
    }()

    init(network: NetworkClient = NetworkClient.shared, keychainProvider: KeychainProvider = KeychainManager()) {
        self.network = network
        self.keychainProvider = keychainProvider
    }
    
    // MARK: - User Account
    
    public func account(_ sessionIdentifier: SessionIdentifier, completion: @escaping (Result<UserModel, Error>) -> Void) {

        guard let request = RequestBuilder.default.accountRequest(sessionIdentifier: sessionIdentifier) else {

            completion(.failure(NSError(domain: "\(type(of: self))", code: 1, userInfo: nil)))
            return
        }

        network.dataTask(with: request) { (data, response, error) in
        let decoder = XMLDecoder()
        decoder.shouldProcessNamespaces = true
            let user = try? decoder.decode(UserModel.self, from: data!)

            completion(.success(user))
        }
        .resume()
    }

    // MARK: - Charges

    func charges(sessionIdentifier: SessionIdentifier, completion:@escaping ((_ error: Error?, _ charges: [Charge]) -> (Void))) {

        guard let request = RequestBuilder.default.accountRequest(sessionIdentifier: sessionIdentifier) else {
            completion(NSError(domain: "\(type(of: self))", code: 1, userInfo: nil), [])
            return
        }

        network.dataTask(with: request) { (data, response, error) in
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
        .resume()
    }

    // MARK: - Loans

    public func loans(_ credentials: Credentials, authenticationManager: AuthenticationManager, completion:@escaping ((_ error:Error?, _ loans: [FlamingoLoan])->(Void))) {

        guard let sessionIdentifier = authenticationManager.sessionIdentifier(for: credentials.username) else {
            return
        }

        var loans = [FlamingoLoan]()

        guard let req = RequestBuilder.default.loansRequest(sessionIdentifier: sessionIdentifier),
              let baseUrl = URL(string: baseUrlString) else {
            completion(NSError(domain: "\(type(of: self))", code: 3, userInfo: nil), loans)
            return
        }

        let finishedCompletion = { (count: Int, loans: [FlamingoLoan]) -> Void in
            guard count == 0 else {
                return
            }

            completion(nil, loans.sorted { (a, b) -> Bool in
                a.expiryDate ?? Date() < b.expiryDate ?? Date()
            })
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
                self.detailedLoan(loan: minimalLoan) {
                    loans.append(minimalLoan)
                    numberOfLoansToProcess -= 1
                    finishedCompletion(numberOfLoansToProcess, loans)
                }
            })
        })
        task.resume()
    }

    private func detailedLoan(loan: FlamingoLoan, completion: @escaping () -> Void ) {
        guard let identifier = loan.identifier, let request = RequestBuilder.default.itemDetailsRequest(itemIdentifier: identifier) else {
            defer {
                completion()
            }
            return
        }

        let task = network.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            let parser = ItemDetailsParser()
            let infoPairs = parser.searchResultDetails(for: data)
            infoPairs.forEach({ (infoPair) in
                if infoPair.title == "Author" {
                    loan.author = infoPair.content
                } else if infoPair.title == "data titel-lang" {
                    loan.title = infoPair.content
                } else if infoPair.title == "data signatur" {
                    loan.signature = infoPair.content
                } else if infoPair.title == "data isbn-ean" {
                    loan.ean = infoPair.content
                } else if infoPair.title == "MaterialTypeName" {
                    loan.materialName = infoPair.content
                } else if infoPair.title == "InterestLevelName" {
                    loan.interestLevelName = infoPair.content
                } else if infoPair.title == "data erschienen" {
                    loan.publishedYear = infoPair.content
                } else if infoPair.title == "BACOWN" {
                    loan.owner = infoPair.content
                } else if infoPair.title == "data preis" {
                    loan.price = infoPair.content
                } else if infoPair.title == "data sprache" {
                    loan.language = infoPair.content
                } else if infoPair.title == "identifier" {
                    
                } else {

                }
            })
            completion()
        })
        task.resume()
    }

    // MARK: - Renewal

    public func renew(credentials: Credentials, accountStore: AccountStoring, itemIdentifier: String, completion:@escaping ((_ renewState: RenewStatus) -> Void)) {

        os_log(.info, log: self.log, "Initiating renewal of %{private}@.", itemIdentifier)
        let credentialStore = AccountCredentialStore(keychainProvider: keychainProvider)
        let authenticationSubject = AuthenticationStateSubject(.idle)
        let authenticationManager = AuthenticationManager(network: network,
                                                          credentialStore: credentialStore,
                                                          authenticationSubject: authenticationSubject)
        authenticationSubject
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { done in
                switch done {
                case .failure(_): os_log(.info, log: self.log, "Failed to authenticate during renewal")
                case .finished: os_log(.info, log: self.log, "Finished authentication during renewal")
                }
            }, receiveValue: { authenticated in
                guard let token = authenticationManager.sessionIdentifier(for: credentials.username) else {
                    completion(.error(NSError(domain: "com.elbedev.sync.APIClient.renew", code: 1)))
                    return
                }

                guard let request = RequestBuilder.default.renewRequest(
                        sessionIdentifier: token,
                        itemIdentifier: itemIdentifier) else {
                    completion(.error(NSError(domain: "com.elbedev.sync.APIClient.renew", code: 2)))
                    return
                }

                let task = self.network.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    guard error == nil else {
                        completion(.error(NSError(domain: "com.elbedev.sync.APIClient.renew", code: 3)))
                        return
                    }

                    let renewalParser = RenewalParser()
                    os_log(.info, log: self.log, "Finished renewal")
                    completion(renewalParser.isRenewed(data: data))
                })
                task.resume()
            })
            .store(in: &disposeBag)

        authenticationManager.authenticateAccount(username: credentials.username, password: credentials.password)
    }

}
