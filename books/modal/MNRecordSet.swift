//
//  MNRecordSet.swift
//  books
//
//  Created by merhab on 6‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class MNRecordset {
    
                                                    // declaration
    
    private var fields=[[String:Any]]()
    var ofSet = 0
    var limit = 10
    var tableName : String
    var recordCount : Int
    var recordNo : Int
    var movePosition = 0
    var isEmpty = true
    private var whereSql = ""
    private var orderBySql = ""
    /*!
     * @param sqlClose containe the where and the order by keywords
    */
    private var sqlCloses : String {
            var str = ""
            if whereSql != "" {
                str = " where \(whereSql) "
            }
            if filtered {
                if filter != "" {
                    if str == "" {
                        str = " where \(filter) "
                    }else {
                        str = " AND \(filter) "
                    }
                }
            }
            if orderBySql != ""{
                str = str + " order by \(orderBySql) "
            }
            return str

    }
    private var positionInPage : Int
    var dataBase : MNDatabase //(path: "")
    var field: Dictionary<String, Any> { return getCurrentRecordAsDictionary()}
   private  var sql : String {return "select * from \(tableName) \(sqlCloses)"}
    var filter = "" // the where sql close without the where
    var filtered = false {
        didSet {

            refresh()

    }
    }
    
                                                        // implementation
    
    convenience init (database:MNDatabase,table:String) {
        
        
        self.init(database: database, tableName: table, SQL: "")
        
    }
    private func getRecordsCount()->Int {
        var str = ""
        let sqlCloseTmp = sqlCloses
        if sqlCloseTmp != "" {
            str = " select count(id) as recordCount from \(tableName)  \(sqlCloseTmp) "
        }
        else {
        str = "select count(id) as recordCount  from \(tableName) "
        }
        
 
        return Int(dataBase.getRecords(query: str, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
    }
   
    /*!
    * @brief this function will reset the recordset
    */
    private func initialisation(){
        ofSet=0
        var sql = ""
        if sqlCloses != "" {
            sql = "select count(id) as recordCount from \(tableName)  \(sqlCloses)"
        }else {
            sql = "select count(id) as recordCount from \(tableName) "
        }
        recordCount = Int(dataBase.getRecords(query: sql, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
        if sqlCloses != "" {
            sql = "select * from \(tableName)  \(sqlCloses)"
        }else {
            sql = "select * from \(tableName) "
        }

        
        if recordCount > 0
        {
            if sql == ""{fields=dataBase.getRecords(of: tableName, ofset: ofSet, limit: limit)}
            else{fields = dataBase.getRecords(query: sql, ofset: ofSet, limit: limit)}
        } else {fields = [[String:Any]]()}
        isEmpty = (fields.count == 0)
        if isEmpty {
            recordNo = -1
            positionInPage = -1
        }else {
            recordNo = 0
            positionInPage = 0
        }
        
        

    }
    
     init (database : MNDatabase ,tableName : String , SQL : String){
        self.dataBase = database
        self.tableName = tableName

        var sql = ""

        self.dataBase = database

         sql = "select count(id) as recordCount from \(tableName)"
        recordCount = Int(database.getRecords(query: sql, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
        if recordCount > 0
        {


            if SQL == ""{fields=database.getRecords(of: tableName, ofset: ofSet, limit: limit)}
            else{fields = database.getRecords(query: SQL, ofset: ofSet, limit: limit)}
        } else {fields = [[String:Any]]()}
        isEmpty = (fields.count == 0)
        if isEmpty {
            recordNo = -1
            positionInPage = -1
        }else {
            recordNo = 0
            positionInPage = 0
        }

    }
    /*!
     * @brief initialise the recordset with where and order by
     * @param whereSql is String without the 'WHERE' keyword
     * @param orderBy is String without 'ORDER BY' keyword
     */
    init (database : MNDatabase ,tableName : String , whereSql : String , orderBy : String){
        
        self.dataBase = database
        self.tableName = tableName
        self.whereSql = whereSql
        self.orderBySql=orderBy
        var sql = ""
        if whereSql != "" {
           sql = "select count(id) as recordCount from \(tableName) where \(whereSql)"
        }else {
          sql = "select count(id) as recordCount from \(tableName) "
        }
        recordCount = Int(database.getRecords(query: sql, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
        if whereSql != "" {
            sql = "select * from \(tableName) where \(whereSql)"
        }else {
            sql = "select * from \(tableName) "
        }
        if orderBy != "" {
            sql = sql + " order by \(orderBy)"
        }
        
        if recordCount > 0
        {
            if sql == ""{fields=database.getRecords(of: tableName, ofset: ofSet, limit: limit)}
            else{fields = database.getRecords(query: sql, ofset: ofSet, limit: limit)}
        } else {fields = [[String:Any]]()}
        isEmpty = (fields.count == 0)
        if isEmpty {
            recordNo = -1
            positionInPage = -1
        }else {
            recordNo = 0
            positionInPage = 0
        }

        
    }
    
    init (database : MNDatabase ,tableName : String ,columns:String ,whereSql : String , orderBy : String){
        
        
        self.dataBase = database
        self.tableName = tableName
        self.whereSql = whereSql
        self.orderBySql=orderBy
        var sql = ""
        if whereSql != "" {
            sql = "select count(id) as recordCount from \(tableName) where \(whereSql)"
        }else {
            sql = "select count(id) as recordCount from \(tableName) "
        }
        recordCount = Int(database.getRecords(query: sql, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
        if whereSql != "" {
            sql = "select \(columns) from \(tableName) where \(whereSql)"
        }else {
            sql = "select \(columns) from \(tableName) "
        }
        if orderBy != "" {
            sql = sql + " order by \(orderBy)"
        }
        if recordCount > 0
        {
            if sql == ""{fields=database.getRecords(of: tableName, ofset: ofSet, limit: limit)}
            else{fields = database.getRecords(query: sql, ofset: ofSet, limit: limit)}
        } else {fields = [[String:Any]]()}
        isEmpty = (fields.count == 0)
        if isEmpty {
            recordNo = -1
            positionInPage = -1
        }else {
            recordNo = 0
            positionInPage = 0
        }
        
    }
    

    
    func move(to position:Int) {
        if position<recordCount,position>=0{
            recordNo=position
            positionInPage = position % limit
            if position>=((ofSet+limit)) || position < ofSet {
                ofSet = position - (position % limit)
                
                let sql = "select * from \(tableName)"
                fields = dataBase.getRecords(query: sql, ofset: ofSet, limit: limit)
            }
            
        }
    }
    func refresh(){

        initialisation()

        
    }
    func moveNext()  {
        if movePosition <  recordCount-1 {
            recordNo += 1

            move(to: recordNo)
        }
         if movePosition < recordCount {movePosition += 1}
    }
    func movePreior()  {
        
        if movePosition > 0{
            recordNo -= 1

            move(to: recordNo)
        }
        if movePosition > -1 {movePosition -= 1}
    }
    func moveFirst()  {
        recordNo = 0
        movePosition = 0
        move(to: 0)
    }
    
    func moveLast()  {
        recordNo = recordCount-1
        movePosition = recordCount-1
        move(to: recordNo)
    }
    func eof() -> Bool {
        return movePosition == recordCount
    }
    func bof() -> Bool {
        return movePosition == -1
    }
    
    func getCurrentRecordAsDictionary()->[String:Any] {
        if positionInPage >= 0 {
        return fields[positionInPage]
        } else {
            return [String:Any]()
        }
    }
    

//    func getObject(myRd : MNrecord)-> MNrecord {
//
//       return DBMNrecord(database: database, record: myRd).getObject( fld: getField())
//
//
//
//    }
    
    //*********************
    

    
    
}

