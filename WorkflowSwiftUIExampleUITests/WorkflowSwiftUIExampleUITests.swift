//
//  WorkflowSwiftUIExampleUITests.swift
//  WorkflowSwiftUIExampleUITests
//
//  Created by Tyler Thompson on 10/20/19.
//  Copyright © 2019 Tyler Thompson. All rights reserved.
//

import XCTest
extension CharacterSet {
    func containsUnicodeScalars(of character: Character) -> Bool {
        return character.unicodeScalars.allSatisfy(contains(_:))
    }
}

class WorkflowSwiftUIExampleUITests: XCTestCase {
    let app = XCUIApplication()

//    override class var defaultTestSuite: XCTestSuite {
//        let suite = XCTestSuite(forTestCaseClass: WorkflowSwiftUIExampleUITests.self)
//        let testNames = suite.tests.compactMap{ test -> String? in
//            if let name = test.name.components(separatedBy: .whitespaces).last {
//                return String(name.filter { CharacterSet.letters.containsUnicodeScalars(of: $0) })
//            }
//            return nil
//        }
//        assert(TestViews.views.keys.allSatisfy(testNames.contains(_:)), "\(TestViews.views.keys) does not contain all keys in \(testNames)")
//        print(testNames)
//        return suite
//    }
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    override func tearDown() {
        app.terminate()
    }

    func testExample() {
//        let key = String("\(#function)".filter { CharacterSet.letters.containsUnicodeScalars(of: $0) })
//        print(key)
//        app.launchEnvironment["testView"] = key
//        app.launch()
//        
//        let nextButton = app.buttons["Next"]
//        nextButton.tap()
//
//        let backButton = app.navigationBars["_TtGC7SwiftUIP13$7fff2c67695028DestinationHosting"].buttons["Back"]
//        backButton.tap()
//        nextButton.tap()
//        app.buttons["Almost!!"].tap()
//        backButton.tap()
    }
}
