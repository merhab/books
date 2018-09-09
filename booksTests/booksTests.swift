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
    if MNFile.createFolderInDocuments(folder: MNFile.booksFolderName) {
        let db = MNDatabase(path: "/Users/merhab/Documents/KOTOB/1.kitab")
        print(db.getTableStruct(table: "BookInfo"))
        
        var databaseBookList : MNDatabase
        
        databaseBookList = MNDatabase(path: MNFile.getDataBasePath(book: "booksList.kitab"))
        let dbBooksList = DBMNrecord(database: databaseBookList, record: BooksList())
        _ = dbBooksList.createTable()
        _ = dbBooksList.updateTableStruct()
        
        
        func moveFile(file :String)-> Bool {// TODO  move files must makes a log file
            
            var databaseBook : MNDatabase
            databaseBook = MNDatabase(path: file)
            let dbBookInfoFromBooksList = DBMNrecord (database: databaseBookList, record: BooksList())
            let dbBookInfoFromBook = DBMNrecord(database: databaseBook, record: BooksList())
            dbBookInfoFromBook.getRecordWithId(ID: 1)
            if !dbBookInfoFromBook.isNull {
                dbBookInfoFromBooksList.getFirstRecord(filter: " bkId = \((dbBookInfoFromBook.record as! BooksList).bkId)")
                if dbBookInfoFromBooksList.isNull {
                    dbBookInfoFromBooksList.record = dbBookInfoFromBook.record
                    _ = dbBookInfoFromBooksList.insert()
                }else {
                    if dbBookInfoFromBook.record > dbBookInfoFromBooksList.record {
                        dbBookInfoFromBooksList.record = dbBookInfoFromBook.record
                        _ = dbBookInfoFromBooksList.update()
                    } else {
                        _ = MNFile.deleteFile(path: file)
                        return false
                    }
                }
            }else{
                _ = MNFile.deleteFile(path: file)
                return false
            }
            
            if   MNFile.moveFileToBookFolder(file: file) {
                return true
            }else{
                return false
            }
            
            
        }
        
        // will move all books files from resource to the book directory in doc

            var any =  MNFile.searchDbFilesInRes(myFunc: moveFile)
            any.append(contentsOf: MNFile.searchDbFilesInDoc(myFunc: moveFile))
            print(any)
        }
        
        
        
        
        
        
        
        
        
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
