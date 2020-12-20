//
//  RorschachSupport.swift
//  BooksUITests
//
//  Created by Kim Dung-Pham on 15.11.20.
//  Copyright © 2020 Martin Kim Dung-Pham. All rights reserved.
//

import Rorschach
import XCTest

struct Context {
    let app: XCUIApplication
    let test: XCTestCase
}

class GeneralAssertion: Assertion<Context> {
    let content: (() -> ())?
    let contentWithContext: ((_ context: Context) -> ())?
    let _title: String

    convenience init(_ title: String, contentWithContext: ((_ context: Context)->())? = nil) {
        self.init(title, contentWithContext: contentWithContext, content: nil)
    }

    convenience init(_ title: String, content: (()->())? = nil) {
        self.init(title, contentWithContext: nil, content: content)
    }

    init(_ title: String, contentWithContext: ((_ context: Context)->())?, content: (()->())?) {
        self.content = content
        self.contentWithContext = contentWithContext
        self._title = title
    }

    override var title: String {
        _title
    }

    override func assert(in context: Context) {
        content?()
        contentWithContext?(context)
    }
}

class GeneralStep: Step<Context> {
    let content: (() -> ())?
    let contentWithContext: ((_ context: inout Context) -> ())?
    let _title: String

    convenience init(_ title: String, contentWithContext: ((_ context: inout Context)->())? = nil) {
        self.init(title, contentWithContext: contentWithContext, content: nil)
    }

    convenience init(_ title: String, content: (()->())? = nil) {
        self.init(title, contentWithContext: nil, content: content)
    }

    init(_ title: String, contentWithContext: ((_ context: inout Context)->())?, content: (()->())?) {
        self.content = content
        self.contentWithContext = contentWithContext
        self._title = title
    }

    override var title: String {
        _title
    }

    override func execute(in context: inout Context) {
        content?()
        contentWithContext?(&context)
    }
}
