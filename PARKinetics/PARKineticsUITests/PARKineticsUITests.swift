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
        app.staticTexts["FINGER TWISTER"].tap()
        app.buttons["HamIcon"].tap()
        app.buttons["Main Menu"].tap()
        app.staticTexts["ADVENTURE STORY"].tap()
        app.buttons["Button"].tap()
        app.buttons["Quit"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 2).children(matching: .other).element
        element.children(matching: .other).element(boundBy: 2).children(matching: .button).element.tap()
        element.children(matching: .other).element(boundBy: 1).children(matching: .button).element.swipeLeft()
        
    }

}
