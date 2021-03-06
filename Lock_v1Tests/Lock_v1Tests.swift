//
//  Lock_v1Tests.swift
//  Lock_v1Tests
//
//  Created by Nikhil vedi on 14/12/2016.
//  Copyright © 2016 Nikhil Vedi. All rights reserved.
//

import XCTest
@testable import Lock_v1

class Lock_v1Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLockIDPresent() {
        //test if a lockID is present in userdefaults 
        
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "LockIDPresent"), "true")
    }
    
    func testIPPresent() {
        //test if the IP is present in the application 
        
        XCTAssertTrue(((UserDefaults.standard.value(forKey: "userIP") != nil)), "localhost")

    }
    
}
