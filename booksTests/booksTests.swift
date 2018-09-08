//
//  booksTests.swift
//  booksTests
//
//  Created by merhab on 7‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import XCTest
@testable import books

class booksTests: XCTestCase {
    
   
    
    func testingThings() {
        let db = MNDatabase(path: "/Users/merhab/Documents/KOTOB/1.kitab")
        let array = db.getArrayOfIDs(query: "select ID from book ")
        print(array)
        let rds = MNRecordset(database: db, record: Book())
        rds.filter = " ID = 5 "
        rds.filtered = true
        print(rds.getObject(myRd: Book()).ID)
        rds.moveNext()
        print(rds.getObject(myRd: Book()).ID)
        rds.filtered = false
        print(rds.getObject(myRd: Book()).ID)
        rds.moveNext()
        print(rds.getObject(myRd: Book()).ID)
        rds.moveLast()
        print(rds.getObject(myRd: Book()).ID)
        rds.filter = " ID > 5 "
        rds.filtered=true
        print(rds.getObject(myRd: Book()).ID)
        rds.movePreior()
                print(rds.getObject(myRd: Book()).ID)
        rds.moveFirst()
                print(rds.getObject(myRd: Book()).ID)
        
        
        
    }
    
    func testingDB () {
        let db = MNDatabase(path: "/Users/merhab/Documents/KOTOB/1.kitab")
        print(db.getTableStruct(table: "BookInfo"))
    }

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
    
}
