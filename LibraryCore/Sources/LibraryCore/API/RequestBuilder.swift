//
//  RequestBuilder.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 09.09.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation

final class RequestBuilder {

    /// The default request builder
    static let `default` = RequestBuilder()

    /**
     - returns: An optional `URLRequest` that can be used to retrieve a session identifier
     - parameters:
        - accountIdentifier: The account identifier of the account to retrieve the session identifier for
        - password: The password of the account to retrieve the session identifier for
     */
    func sessionIdentifierRequest(accountIdentifier: String, password: String) -> URLRequest? {
        let requestBody = sessionTokenRequestBody(accountIdentifier: accountIdentifier, password: password)
        return request(with: requestBody, path: "app_webuser/WebUserSvc.asmx", action: "webuser/CheckBorrower")
    }

    /// - returns: An optional `URLRequest` that allows the retrieval of a user's account
    /// - parameter sessionIdentifier: The session identifier that identifies the user
    func accountRequest(sessionIdentifier: String) -> URLRequest? {
        let requestBody = accountRequestBody(sessionIdentifier: sessionIdentifier)
        return request(with: requestBody, path: "app_webuser/WebUserSvc.asmx", action:"webuser/GetBorrowerAccount")
    }

    /// - returns: The optional data that represents the request body for retrieving an account.
    /// - parameter sessionIdentifier: The session identifier needed for authorization
    private func accountRequestBody(sessionIdentifier: String) -> Data? {
        let template = RequestTemplate.accountRequestBodyTemplate
        return dataByFillingTemplate(template,
                                     arguments: [sessionIdentifier] as [CVarArg])
    }

    /**
     - returns: Optional data that represents the request body for session token requests
     - parameters:
        - accountIdentifier: The account identifier of the account to retrieve the session identifier for
        - password: The password of the account to retrieve the session identifier for
     */
    private func sessionTokenRequestBody(accountIdentifier: String, password: String) -> Data? {
        let template = RequestTemplate.sessionIdentifierRequestBodyTemplate
        return dataByFillingTemplate(template, arguments: [accountIdentifier, password] as [CVarArg])
    }

    /// - returns: An optional `URLRequest` that allows retrieval of loans
    /// - parameter sessionIdentifier: The session identifier that identifies the account
    func loansRequest(sessionIdentifier: String) -> URLRequest? {
        let requestBody = loansRequestBody(sessionIdentifier: sessionIdentifier)
        return request(with: requestBody, path: "app_webuser/WebUserSvc.asmx", action:"webuser/GetBorrowerLoans")
    }

    /// - returns: The optional data that represents the request body for retrieving loans.
    /// - parameter sessionIdentifier: The session identifier needed for authorization
    private func loansRequestBody(sessionIdentifier: String) -> Data? {
        let template = RequestTemplate.loansRequestBodyTemplate
        return dataByFillingTemplate(template, arguments: [sessionIdentifier] as [CVarArg])
    }

    /// - returns: An optional `URLRequest` that allows the retrieval of a users credits
    /// - parameter sessionIdentifier: The session identifier that identifies the user
    func creditsRequest(sessionIdentifier: String) -> URLRequest? {
        let requestBody = creditsRequestBody(sessionIdentifier: sessionIdentifier)
        return request(with: requestBody, path: "app_webuser/WebUserSvc.asmx", action:"webuser/GetBorrowerCredits")
    }

    /// - returns: The optional data that represents the request body for retrieving credits.
    /// - parameter sessionIdentifier: The session identifier needed for authorization
    private func creditsRequestBody(sessionIdentifier: String) -> Data? {
        let template = RequestTemplate.creditsRequestBodyTemplate
        return dataByFillingTemplate(template, arguments: [sessionIdentifier] as [CVarArg])
    }

    /**
     - returns: An optional `URLRequest` to retrieve the details of an item
     - parameters:
        - itemIdentifier: The identifier of the item to retrieve
     */
    func itemDetailsRequest(itemIdentifier: String) -> URLRequest? {
        let requestBody = itemDetailsRequestBody(itemIdentifier: itemIdentifier)
        return request(with: requestBody, path: "WebCat/WebCatalogueSvc.asmx", action: "webcatalogue/GetCatalogueRecord")
    }

    /**
     - returns: The optional data that represents the request body for retrieving item details
     - parameter itemIdentifier:
     */
    func itemDetailsRequestBody(itemIdentifier: String) -> Data? {
        let template = RequestTemplate.itemDetailsRequestBodyTemplate
        return dataByFillingTemplate(template, arguments: [itemIdentifier] as [CVarArg])
    }

    /**
     - returns: An optional `URLRequest` that allows renewing of an item
     - parameters:
        -  sessionIdentifier: The session identifier of the belonging account
        -  itemIdentifier: The identifier of the item to renew
     */
    func renewRequest(sessionIdentifier: String, itemIdentifier: String) -> URLRequest? {
        let requestBody = renewRequestBody(sessionIdentifier: sessionIdentifier, itemIdentifier: itemIdentifier)
        return request(with: requestBody, path: "app_webuser/WebUserSvc.asmx", action:"webuser/RenewItem")
    }

    /**
     - returns: Optional data that represents the request body for renewing items.
     - parameters:
        - sessionIdentifier: The session identifier needed for authorization
        - itemIdentifier: The identifier of the item to renew
     */
    private func renewRequestBody(sessionIdentifier: String, itemIdentifier: String) -> Data? {
        let template = RequestTemplate.renewRequestBodyTemplate
        return dataByFillingTemplate(template, arguments: [sessionIdentifier, itemIdentifier] as [CVarArg])
    }

    /// - returns: An optional `URLRequest` for the given body and SOAP action
    private func request(with body: Data?, path: String, action: String) -> URLRequest? {
        return URLRequest.request(method: "POST",
                                  host: "zones.buecherhallen.de",
                                  path: path,
                                  body: body,
                                  headers: ["Content-Type": "text/xml; charset=utf-8",
                                            "SOAPAction": "http://bibliomondo.com/websevices/\(action)",
                                    "Accept": "*/*",
                                    "Accept-Language": "en-us",
                                    "Accept-Encoding": "br, gzip, deflate"])
    }

    /**
     Fills the template at the given path with the arguments.
     - parameters:
        - path: The path to the template
        - arguments: The arguments to fill the template with
     */
    internal func dataByFillingTemplate(_ template: String, arguments: [CVarArg] = []) -> Data? {
        let body = String(format: template, arguments: arguments)
        return body.data(using: .utf8)
    }

}
