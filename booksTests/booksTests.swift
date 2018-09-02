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
        let fld = rds.getField()
        
        let props = try! properties(myBook)
        print (props)
       
        
        var str = ""
        for i in props.indices {
            str = String(describing: type(of: props[i].value))
            
            print ("\(String(describing: fld[props[i].key] )) : \(props[i].value)")
            if props[i].key != "ID" {
            if str == "String"  {
                
                try! set(fld[props[i].key] ?? "", key: props[i].key, for: &myBook )
             

            } else if str == "Double"{
                try! set(fld[props[i].key] ?? -1.0, key: props[i].key, for: &myBook )
            }else {
                try! set(fld[props[i].key] ?? -1, key: props[i].key, for: &myBook )

                }
            }
            myBook.ID = Int(fld["ID"] as! Int64)
      
        
   
        
        
        XCTAssertNotNil(myBook)
       
        
        }
        print (myBook.pgText)
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
