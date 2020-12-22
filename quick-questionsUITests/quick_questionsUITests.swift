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
        
        //answer
        app.buttons["option1"].tap()
        app.buttons["Check Answer"].tap()
        
        //go to results
        app.buttons["Results"].tap()
        
        //go home
        app.buttons["Home"].tap()
        
        //check that we're at home
        let startQuizBtn = app.buttons["Start Quiz!"]
        XCTAssert(startQuizBtn.exists)
    }
    
    func testChangingNumberOfQuestions() throws {
        let app = XCUIApplication()
        
        //change number of questions
        let numberTF = app.textFields["Number of Questions"]
        numberTF.tap()
        numberTF.typeText("2")
        
        //start quiz
        app.buttons["Start Quiz!"].tap()
        
        //answer
        app.buttons["option2"].tap()
        app.buttons["Check Answer"].tap()
        
        //go to the next question
        app.buttons["Next"].tap()
        
        //answer next question
        app.buttons["option3"].tap()
        app.buttons["Check Answer"].tap()
        
        //check if test is done (meaning we done 2 questions)
        let resultsBtn = app.buttons["Results"]
        XCTAssert(resultsBtn.exists)
    }
    
    func testChangingCategory() throws {
        let app = XCUIApplication()
        
        //change category
        let categoryBtn = app.buttons["categoryBtn"]
        categoryBtn.tap()
        app.buttons["Movies"].tap()
        
        //check if it actually changed
        XCTAssert(categoryBtn.staticTexts["Movies"].exists)
    }
    
    func testChangingDifficulty() throws {
        let app = XCUIApplication()
        
        //change difficulty (default is easy)
        let difficultyBtn = app.buttons["difficultyBtn"]
        difficultyBtn.tap()
        app.buttons["Medium"].tap()
        
        //check if it actually changed
        XCTAssert(difficultyBtn.staticTexts["Medium"].exists)
    }
    
    func testNotChoosingAnswer() throws {
        let app = XCUIApplication()
        app.buttons["Start Quiz!"].tap()
        
        //answer
        app.buttons["Check Answer"].tap()
        
        //check to see if we're shown the need answer popup
        let okBtn = app.buttons["Ok!"]
        XCTAssert(okBtn.exists)
    }
    
    func testSelectingAndDeselectingAnswer() throws {
        let app = XCUIApplication()
        app.buttons["Start Quiz!"].tap()
        
        //answer
        app.buttons["option4"].tap()
        app.buttons["option4"].tap()
        app.buttons["Check Answer"].tap()
        
        //check to see if we're shown the need answer popup
        let okBtn = app.buttons["Ok!"]
        XCTAssert(okBtn.exists)
    }
}
