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
    var isEmpty = true
    private var whereSql = ""
    private var orderBySql = ""
    private var sqlCloses : String {
        get{
            var str = ""
            if whereSql != "" {
                str = " where \(whereSql) "
            }
            if filtered {
                if filter != "" {
                    if str == "" {
                        str = "where \(filter)"
                    }else {
                        str = "AND \(filter)"
                    }
                }
            }
            if orderBySql != ""{
                str = str + " order by \(orderBySql) "
            }
            return str
        }
    }
    private var positionInPage : Int
    var dataBase : MNDatabase //(path: "")
    var field: Dictionary<String, Any> {
        get{ return getField()}
    }
   private  var sql : String {
        get {


             return "select * from \(tableName) \(sqlCloses)"
            
        }
    }
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
        if sqlCloses != "" {
            str = " select count(id) as recordCount from \(tableName) where \(sqlCloses) "
        }
        else {
        str = "select count(id) as recordCount  from \(tableName) "
        }
        
 
        return Int(dataBase.getRecords(from: str, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
    }
   
    private func initialisation(){



        recordCount = getRecordsCount()
        if recordCount > 0
        {

            
            fields=dataBase.getRecords(of: tableName, ofset: ofSet, limit: limit)

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
        recordCount = Int(database.getRecords(from: sql, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
        if recordCount > 0
        {


            if SQL == ""{fields=database.getRecords(of: tableName, ofset: ofSet, limit: limit)}
            else{fields = database.getRecords(from: SQL, ofset: ofSet, limit: limit)}
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
        recordCount = Int(database.getRecords(from: sql, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
        if whereSql != "" {
            sql = "select * from \(tableName) where \(whereSql)"
        }else {
            sql = "select * from \(tableName) "
        }
        if recordCount > 0
        {
            if sql == ""{fields=database.getRecords(of: tableName, ofset: ofSet, limit: limit)}
            else{fields = database.getRecords(from: sql, ofset: ofSet, limit: limit)}
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
        recordCount = Int(database.getRecords(from: sql, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
        if whereSql != "" {
            sql = "select \(columns) from \(tableName) where \(whereSql)"
        }else {
            sql = "select \(columns) from \(tableName) "
        }
        if recordCount > 0
        {
            if sql == ""{fields=database.getRecords(of: tableName, ofset: ofSet, limit: limit)}
            else{fields = database.getRecords(from: sql, ofset: ofSet, limit: limit)}
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
                fields = dataBase.getRecords(from: sql, ofset: ofSet, limit: limit)
            }
            
        }
    }
    func refresh(){
        let n = recordNo
        initialisation()
        move(to: n)
        
    }
    func moveNext()  {
        if !eof() {
            recordNo += 1
            move(to: recordNo)
        }
    }
    func movePreior()  {
        if !bof(){
            recordNo -= 1
            move(to: recordNo)
        }
    }
    func moveFirst()  {
        recordNo = 0
        move(to: 0)
    }
    
    func moveLast()  {
        recordNo = recordCount-1
        
        move(to: recordNo)
    }
    func eof() -> Bool {
        return recordNo == recordCount-1
    }
    func bof() -> Bool {
        return recordNo == 0
    }
    func getField()->[String:Any] {
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

