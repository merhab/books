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

        let str =  NSStringFromClass(Book.self)
        let c = NSClassFromString("Book")?.initialize()
        //(c as! Book).pgId
        let newString = str.replacingOccurrences(of: ".Type", with: "", options: .literal, range: nil)
        print(newString)
    }
//    static func nour<T> ()->T{
//    let str = String(describing:type(of: T.self))
//    }
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
