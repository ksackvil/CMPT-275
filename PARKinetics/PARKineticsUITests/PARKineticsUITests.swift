//
//  PARKineticsUITests.swift
//  PARKineticsUITests
//
//  Created by Kai Sackville-Hii on 2019-10-04.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//

import XCTest

class PARKineticsUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameLoadingAndProgress() {
        
        let app = XCUIApplication()
        app.staticTexts["Speech based adventure"].tap()
        app.buttons["Play"].tap()
        app.buttons["Button"].tap()
        
        let mainMenuButton = app.buttons["Main Menu"]
        mainMenuButton.tap()
        app.staticTexts["Practice your dexterity"].tap()
        app.buttons["Level 1"].tap()
        
        let hamiconButton = app.buttons["HamIcon"]
        hamiconButton.tap()
        app.buttons["Resume"].tap()
        hamiconButton.tap()
        mainMenuButton.tap()
        app.staticTexts["PARKinetics"].swipeLeft()
        
        
    }

}
