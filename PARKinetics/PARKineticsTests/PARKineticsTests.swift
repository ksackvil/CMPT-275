//
//  PARKineticsTests.swift
//  PARKineticsTests
//
//  Created by Kai Sackville-Hii on 2019-10-04.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//

import XCTest
@testable import PARKinetics

class PARKineticsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var uid = DbHelper.createUser(username: "Evan1", email: "evanh@sfu.ca")
        print(uid)
        DbHelper.uploadGame(uid: uid, type: "Finger Twister", balance: "1", facial: "2", speech: "3", dexterity: "4", posture: "5")
        DbHelper.retrieveAllGames(uid: uid, closure: { (games) in
            print(games)
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
