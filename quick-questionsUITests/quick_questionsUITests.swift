//
//  quick_questionsUITests.swift
//  quick-questionsUITests
//
//  Created by karime on 10/7/20.
//

import XCTest

// swiftlint:disable all
class quick_questionsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testQuiz() throws {
        let app = XCUIApplication()
        app.buttons["Start Quiz!"].tap()
        
        app.buttons["option1"].tap()
        app.buttons["Check Answer"].tap()
        
        app.buttons["Results"].tap()
        
        app.buttons["Home"].tap()
        
        let startQuizBtn = app.buttons["Start Quiz!"]
        XCTAssert(startQuizBtn.exists)
    }
}
