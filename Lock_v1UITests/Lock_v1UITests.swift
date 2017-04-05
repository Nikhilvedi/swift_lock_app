
//
//  Lock_v1UITests.swift
//  Lock_v1UITests
//
//  Created by Nikhil vedi on 14/12/2016.
//  Copyright © 2016 Nikhil Vedi. All rights reserved.
//

import XCTest
import TextFieldEffects

class Lock_v1UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func lockNunlock()
    {
        //lock and unlock successfull!
        let app = XCUIApplication()
        app.buttons["Unlock"].tap()
        
        let okButton = app.alerts["Alert"].buttons["Ok"]
        okButton.tap()
        app.buttons["Lock"].tap()
        okButton.tap()
        app.buttons["Logout"].tap()
        app.alerts["Message"].buttons["Ok"].tap()
        
    }
    
    func inNout()
    {
        
        let app = XCUIApplication()
        app.buttons["See in-and-out"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery.staticTexts["John@example.com UNLOCK At: April 1, 2017 5:14 PM "].tap()
        
        let nv94HotmailCoUkUnlockAtApril420171113AmStaticText = tablesQuery2.cells.containing(.staticText, identifier:"nv94@hotmail.co.uk UNLOCK At: April 4, 2017 11:13 AM ").children(matching: .staticText).matching(identifier: "nv94@hotmail.co.uk UNLOCK At: April 4, 2017 11:13 AM ").element(boundBy: 0)
        nv94HotmailCoUkUnlockAtApril420171113AmStaticText.tap()
        nv94HotmailCoUkUnlockAtApril420171113AmStaticText.tap()
        tablesQuery.staticTexts["nv94@hotmail.co.uk UNLOCK At: April 3, 2017 4:35 PM "].swipeDown()
        tablesQuery.staticTexts["nv94@hotmail.co.uk UNLOCK At: April 1, 2017 5:49 PM "].tap()
        nv94HotmailCoUkUnlockAtApril420171113AmStaticText.swipeLeft()
        app.buttons["Back"].tap()
        
    }
    
}
