//
//  booksTests.swift
//  booksTests
//
//  Created by merhab on 20‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import XCTest
@testable import books

class booksTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let database = MNDatabase(path: "/Users/merhab/Documents/KOTOB/4.kitab")
        let result = database.getRecords(query: "select rowid,pgText from bookInd where pgText MATCH 'الله';")
        let a = result[0]
        print(a["pgText"] as! String)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
