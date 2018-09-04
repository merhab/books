//
//  booksTests.swift
//  booksTests
//
//  Created by merhab on 2‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import XCTest
@testable import books
class booksTests: XCTestCase {
    
    func testConnection()  {
     var db : MNDatabase
        db = MNDatabase(path: "/Users/merhab/Documents/KOTOB/1.kitab")
        XCTAssertNotNil(db, "")
        let rds : MNRecordset
        var myBook = Book()
        rds = MNRecordset(database: db, record: myBook)
        XCTAssertNotNil(rds)
        rds.move(to : 0)
        myBook = rds.getObject(myRd: myBook) as! Book
        print(myBook.pgText)
        rds.move(to : 9)
        myBook = rds.getObject(myRd: myBook) as! Book
        print(myBook.pgText)
        rds.move(to : 10)
        myBook = rds.getObject(myRd: myBook) as! Book
        print(myBook.pgText)
        rds.move(to : 20)
        myBook = rds.getObject(myRd: myBook) as! Book
        print(myBook.pgText)
        rds.move(to : 19)
        myBook = rds.getObject(myRd: myBook) as! Book
        print(myBook.pgText)
      
        
   
        
        
        XCTAssertNotNil(myBook)
       
        
       
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
