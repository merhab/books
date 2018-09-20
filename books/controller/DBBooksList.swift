//
//  DBBooksList.swift
//  books
//
//  Created by merhab on 16‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class DBBooksList {
    var rdsBooksList : MNRecordset
    var dbBooksList : DBMNrecord
    var rdsMen : MNRecordset
    var dbMen : DBMNrecord
    var rdsCat : MNRecordset
    var dbCat : DBMNrecord
    var dataBase : MNDatabase
    var path : String
    
    init() {
        _ = MNFile.createDbFolder(folder: MNFile.booksFolderName)
        var databaseExists = false
        if MNFile.fileExists(path: MNFile.getDataBasePath(book: "booksList.kitab")) {
            databaseExists = true
        } else {
            databaseExists = false
        }
       path =  MNFile.getDataBasePath(book: "booksList.kitab")
       dataBase = MNDatabase(path: path)
        dbBooksList = DBMNrecord(database: dataBase, record: BooksList())
        dbMen = DBMNrecord(database: dataBase, record: Men())
        dbCat = DBMNrecord(database: dataBase, record: BooksCat())
        if databaseExists {
            _ = dbBooksList.updateTableStruct()
            _ = dbCat.updateTableStruct()
            _ = dbMen.updateTableStruct()
        }else {
            _ = dbBooksList.createTable()
            _ = dbCat.createTable()
            _ = dbMen.createTable()
            (dbCat.record as! BooksCat).bkCatTitle = "كل الكتب"
            dbCat.record.ID = 1
            (dbCat.record as! BooksCat).bkCatOrder = -1
            _ = dbCat.insert()
        }
        rdsBooksList = MNRecordset(database: dataBase, table: dbBooksList.tableName)

        rdsMen = MNRecordset(database: dataBase, table: dbMen.tableName)

        rdsCat = MNRecordset(database: dataBase, tableName: dbCat.tableName, whereSql: "", orderBy: "bkCatOrder")


    }
    
    func moveFile(files :[String]) {// TODO  move files must makes a log file
        print(files)
        for file in files {
            
            var databaseBook : MNDatabase
            databaseBook = MNDatabase(path: file)
            let dbBookInfoFromBooksList = DBMNrecord (database: dataBase, record: BooksList())
            let dbBookInfoFromBook = DBMNrecord(database: databaseBook, record: BooksList())
            let dbMenFromBooksList = DBMNrecord (database: dataBase, record: Men())
            let dbMenFromBook = DBMNrecord(database: databaseBook, record: Men())
            let dbCatFromBooksList = DBMNrecord (database: dataBase, record: BooksCat())
            let dbCatFromBook = DBMNrecord(database: databaseBook, record: BooksCat())
            //print( dbBookInfoFromBook.updateTableStruct())
            dbBookInfoFromBook.getRecordWithId(ID: 1)
            if !dbBookInfoFromBook.isNull {
                dbBookInfoFromBooksList.getFirstRecord(filter: " bkId = \((dbBookInfoFromBook.record as! BooksList).bkId)")
                
                _ = dbBookInfoFromBooksList.saveOrUpdate(dbRecord: dbBookInfoFromBook)
                
                dbMenFromBook.getRecordWithId(ID: 1)
                if !dbMenFromBook.isNull {
                    dbMenFromBooksList.getFirstRecord(filter: "menId = \((dbMenFromBook.record as! Men).menId)")
                    _ = dbMenFromBooksList.saveOrUpdate(dbRecord: dbMenFromBook)
                }
                
                dbCatFromBook.getRecordWithId(ID: 1)
                if !dbCatFromBook.isNull {
                    dbCatFromBooksList.getFirstRecord(filter: "bkCatId = \((dbCatFromBook.record as! BooksCat).bkCatId)")
                    _ = dbCatFromBooksList.saveOrUpdate(dbRecord: dbCatFromBook)
                }
                
            }else{
                _ = MNFile.deleteFile(path: file)
                print ("error no info found file deleted  : \(file)")
                
            }
            
            if   MNFile.moveFileToBookFolder(file: file) {
                print ("file moved to book folder: \(file)")
                #if os(OSX)
                let bookId = MNFile.getIdFromPath(path: file)
                if bookId != -1 {
                 let dbFahres = DBFahresKalimat(kitabId:bookId)
                        if MNDatabase.tableIsEmpty(path: MNFile.getFihrasPathFromBookId(bookId: bookId), table: MNKalima().getTableName()){
                            dbFahres.fahrasatKitab()
                    }
                }
                #endif
                
            }else{
                print ("error cant moved to book folder: \(file)")
            }
        }
        
    }
    

    /**
     find and move all books from res , doc , inbox to KOTOB folder
     this will not move indexes
     */
    func getDataBases()  {
        var files =  MNFile.searchDbFilesInRes()
        files.append(contentsOf: MNFile.searchDbFilesInDoc())
        files.append(contentsOf: MNFile.searchDbFilesInInbox())
        moveFile(files: files)
        rdsBooksList.refresh()
        rdsCat.refresh()
        rdsMen.refresh()
    }
    
    func getINdexes()  {

    }

}
