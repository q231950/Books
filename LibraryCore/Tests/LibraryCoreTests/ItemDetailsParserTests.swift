//
//  ItemDetailsParserTests.swift
//  BTLBTests
//
//  Created by Martin Kim Dung-Pham on 01.09.18.
//  Copyright © 2018 elbedev. All rights reserved.
//

import XCTest
@testable import LibraryCore

class ItemDetailsParserTests: XCTestCase {

    func testParseDetails() {
        let parser = ItemDetailsParser()

        let data = publicLoanDetailResponseBody
        let details = parser.searchResultDetails(for: data)
        let expectedDetails = [FlamingoInfoPair(title: "Author", content: "Ferguson Smart, John"),
                               FlamingoInfoPair(title: "data titel-lang", content: "Jenkins: the definitive guide"),
                               FlamingoInfoPair(title: "data signatur", content: "Jd 0#FERG•/21 Jd 0"),
                               FlamingoInfoPair(title: "identifier", content: "T01540384X"),
                               FlamingoInfoPair(title: "data isbn-ean", content: "978 1 44930535 2"),
                               FlamingoInfoPair(title: "MaterialTypeName", content: "Buch Erwachsene"),
                               FlamingoInfoPair(title: "InterestLevelName", content: "Erw.Sachb."),
                               FlamingoInfoPair(title: "data erschienen", content: "2011"),
                               FlamingoInfoPair(title: "BACOWN", content: "Zentralbibliothek"),
                               FlamingoInfoPair(title: "data preis", content: "€ 36,50"),
                               FlamingoInfoPair(title: "data sprache", content: "englisch")]

        XCTAssertEqual(details, expectedDetails)
    }

    func testDebugDescription() {
        let pair = FlamingoInfoPair(title: "Bird Type", content: "Flamingo")
        XCTAssertEqual(pair.debugDescription, "FlamingoInfoPair(title: \"Bird Type\", content: \"Flamingo\")")
    }
}
