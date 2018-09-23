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
    var BooksListdataBase : MNDatabase
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
       BooksListdataBase = MNDatabase(path: path)
        dbBooksList = DBMNrecord(database: BooksListdataBase, record: BooksList())
        dbMen = DBMNrecord(database: BooksListdataBase, record: Men())
        dbCat = DBMNrecord(database: BooksListdataBase, record: BooksCat())
        if databaseExists {
            _ = dbBooksList.updateTableStruct()
            _ = dbCat.updateTableStruct()
            _ = dbMen.updateTableStruct()
        }else {
            _ = dbBooksList.createTable()
            _ = dbCat.createTable()
            _ = dbMen.createTable()
            (dbCat.record as! BooksCat).bkCatTitle = "كل الكتب"
            dbCat.record.ID = -1
            (dbCat.record as! BooksCat).bkCatOrder = -1
            _ = dbCat.save()
        }
        rdsBooksList = MNRecordset(database: BooksListdataBase, table: dbBooksList.tableName)

        rdsMen = MNRecordset(database: BooksListdataBase, table: dbMen.tableName)

        rdsCat = MNRecordset(database: BooksListdataBase, tableName: dbCat.tableName, whereSql: "", orderBy: "bkCatOrder")


    }
    
    func moveFile(files :[String]) {// TODO  move files must makes a log file
        print(files)
        for file in files {
            
            var databaseKitab : MNDatabase
            databaseKitab = MNDatabase(path: file)
            let dbBookInfoFromBooksList = DBMNrecord (database: BooksListdataBase, record: BooksList())
            let dbBookInfoFromBook = DBMNrecord(database: databaseKitab, record: BooksList())
            let dbMenFromBooksList = DBMNrecord (database: BooksListdataBase, record: Men())
            let dbMenFromBook = DBMNrecord(database: databaseKitab, record: Men())
            let dbCatFromBooksList = DBMNrecord (database: BooksListdataBase, record: BooksCat())
            let dbCatFromBook = DBMNrecord(database: databaseKitab, record: BooksCat())
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
                    // impliment the KitabSinf table


                    let kitabSinf = MNKitabSinf()
                    var dbMNKitabSinf : DBMNrecord

                    dbMNKitabSinf = DBMNrecord(database: BooksListdataBase, record: kitabSinf)
                    _ = dbMNKitabSinf.createTable()
                    // we use the Cat Id from Mn not from shamelah 
                        kitabSinf.idCat = dbCatFromBook.record.ID
                        kitabSinf.idKitab = (dbBookInfoFromBooksList.record as! BooksList).ID
                        let IDs = BooksListdataBase.getArrayOfIDs(query: kitabSinf.sqlGetEqualRecordFromDatabase)
                    if IDs.isEmpty {
                        _ = dbMNKitabSinf.saveOrUpdte()
                    }
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
                    if MNDatabase.tableIsEmpty(path: MNFile.getFihrasPathFromKitabId(kitabId: bookId), table: MNKalima().getTableName()){
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
    /**
     filter the bookslist by Cat , have to set filtered to true to apply the filter
     - Parameters:
       - catId: the ID of cat from MnRecord not the Shamelah bkCatId
    */
    func setFilterByAsnaf(ID : Int)  {
        let Ids = BooksListdataBase.getArrayOfIDs(query:
            "select booksList.ID from MNKitabSinf left JOIN booksList ON booksList.ID = MNKitabSinf.idKitab where MNKitabSinf.idcat = \(ID)"
        )
        var str = ""
        for i in Ids {
            if str == "" {
                str = "\(i)"
            } else {
                str = str + ",\(i)"
            }
        }
        if str != "" {
            str = "("+str+")"
            rdsBooksList.filter = " Id in \(str)"

    }
    }
    
    func saveSelectedFilteredBooks(idCat : Int , selected : Bool){
        var  str = ""
        
        if selected { str = "1"}else {str = "0"}
        if !rdsBooksList.isEmpty {
            let sqlUpdate = """
            UPDATE bookslist set selected = \(str)  where bookslist.ID in (select booksList.ID
            from MNKitabSinf
            left JOIN booksList
            ON booksList.ID = MNKitabSinf.idKitab
            where MNKitabSinf.idcat = \(idCat) )
"""
            let success = rdsBooksList.dataBase.execute(sqlUpdate)
            print (success)
            rdsBooksList.refresh()
        }
    }

}
