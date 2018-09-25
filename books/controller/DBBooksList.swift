//
//  DBBooksList.swift
//  books
//
//  Created by merhab on 16‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class DBBooksList {
  private  var rdsBooksList : MNRecordset
//    var dbKitab : DbKitab?
    var dbBooksList : DBMNrecord
    var rdsMen : MNRecordset
    var dbMen : DBMNrecord
    var rdsCat : MNRecordset
    var dbCat : DBMNrecord
    var BooksListdataBase : MNDatabase
    var databasePath : String
    var dataBase : MNDatabase {return rdsBooksList.dataBase }
    var recordCount : Int{return rdsBooksList.recordCount}
    var filter : String {
        set {
          rdsBooksList.filter = filter
          self.filterSlaves()
        }
        get{
            return rdsBooksList.filter
        }
    }
    var filtered : Bool {
        set{
          rdsBooksList.filtered = filtered
        }
        get{
            return rdsBooksList.filtered
        }
    }
    
    init() {
        _ = MNFile.createDbFolder(folder: MNFile.booksFolderName)
        var databaseExists = false
        if MNFile.fileExists(path: MNFile.getDataBasePath(book: MNFile.booksListDataBaseName)) {
            databaseExists = true
        } else {
            databaseExists = false
        }
       databasePath =  MNFile.getDataBasePath(book: MNFile.booksListDataBaseName)
       BooksListdataBase = MNDatabase(path: databasePath)
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
            //    #if os(OSX)
                let bookId = MNFile.getIdFromPath(path: file)
                if bookId != -1 {
                 let dbFahres = DBFahresKalimat(kitabId:bookId)
                    if MNDatabase.tableIsEmpty(path: MNFile.getDataBasePath(kitabId: bookId), table: DBFahresKalimat.fahrasTableName){
                            dbFahres.fahrasatKitab()
                    }
                }
            //    #endif
                
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
    func saveSelected() {
        let cat = BooksCat()
        cat.bkCatTitle = MNDate.getTimeStamp()
        cat.bkCatId = -1
        _ = DBMNrecord(database: rdsBooksList.dataBase, record: cat).save()
        let tasnif = MNKitabSinf()
        let dbtasnif = DBMNrecord(database: rdsBooksList.dataBase, record: tasnif)
        let rdsSelected = MNRecordset(database: rdsBooksList.dataBase, tableName: rdsBooksList.tableName, columns: "ID", whereSql: "selected = 1", orderBy: "")
        if !rdsSelected.isEmpty{
            rdsSelected.moveFirst()
            repeat  {
            tasnif.idKitab = Int(rdsBooksList.getCurrentRecordAsDictionary()["ID"] as! Int64)
            tasnif.idCat=cat.ID
            tasnif.ID = -1
            _ = dbtasnif.save()
            rdsSelected.moveNext()
            }while !rdsSelected.eof()

        }

        

    }
    private func filterSlaves(){
        //TODO: filter slaves rds
    }
    
    func awal()  {
         rdsBooksList.moveFirst()
                filterSlaves()
    }
    func lahik()  {
         rdsBooksList.moveNext()
                filterSlaves()
    }
    func sabik() {
        rdsBooksList.movePreior()
                filterSlaves()
    }
    func akhir(){
        rdsBooksList.moveLast()
                filterSlaves()
    }
    func khawi() -> Bool {
        return rdsBooksList.isEmpty
    }
    func bidaya()->Bool{
        return rdsBooksList.bof()
    }
    func nihaya() -> Bool {
        return rdsBooksList.eof()
    }
    
    func refresh (){
        rdsBooksList.refresh()
                filterSlaves()
    }
    func taharakIla(mawki3 : Int){
        rdsBooksList.move(to: mawki3)
    }
    func getFields()->[String:Any]{
        return rdsBooksList.getCurrentRecordAsDictionary()
    }
    
    func getCurrentKitab ()->DbKitab{
        let bookInfo = rdsBooksList.getCurrentRecordAsDictionary()
        let kitabId=Int(bookInfo["bkId"] as! Int64)
        let dbKItab = DbKitab(kitabId: kitabId)
        return dbKItab
    }
    func getCurrentKitabId()->Int{
        let bookInfo = rdsBooksList.getCurrentRecordAsDictionary()
        let kitabId=Int(bookInfo["bkId"] as! Int64)
        return kitabId
    }

}
