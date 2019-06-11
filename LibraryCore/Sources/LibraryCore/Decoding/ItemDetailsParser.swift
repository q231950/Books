//
//  ItemDetailsParser.swift
//  BTLB
//
//  Created by Martin Kim Dung-Pham on 01.09.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import Foundation
import AEXML

class FlamingoInfoPair: NSObject {
    let title: String
    let content: String

    init(title: String, content: String) {
        self.title = title
        self.content = content
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? FlamingoInfoPair else {
            return false
        }

        return title == object.title && content == object.content
    }

    override var debugDescription: String {
        return "FlamingoInfoPair(title: \"\(title)\", content: \"\(content)\")"

    }
}

struct ItemDetailsParser {

    var signature: String?
    let keyMapping = ["Title": "data titel-lang",
                      "Author": "Author",
                      "ClassMark":"data signatur",
                      "BACBAC": "identifier",
                      "BACCNO": "data isbn-ean",
                      "BACYER": "data erschienen",
                      "MaterialTypeName": "MaterialTypeName",
                      "InterestLevelName": "InterestLevelName",
                      "BACOWN": "BACOWN",
                      "BACPRI": "data preis",
                      "BACLTX": "data sprache",
                      "Notes": "data anmerkungen"]
    let unknownKeys = ["CorpAuthor", "IsConceptual", "BACVOL", "BACVO4", "BACVOP", "BACECA", "IsNewRecord"]

    func searchResultDetails(for data: Data?) -> [FlamingoInfoPair] {
        guard let data = data else {
            return []
        }

        var details = [FlamingoInfoPair]()

        do {
            let xml = try AEXMLDocument(xml: data)
            let info = xml.root["soap:Body"]["GetCatalogueRecordResponse"]["GetCatalogueRecordResult"]["xmlDoc"]["GetCatalogueRecordResult"]["SoapActionResult"]

            details = info.children.compactMap({ element -> FlamingoInfoPair? in
                if let title = keyMapping[element.name], element.string.count > 0 {
                    return FlamingoInfoPair(title: title, content: element.string)
                }
                return nil
            })

        } catch let error {
            print(error)
        }
        return details
    }

}
