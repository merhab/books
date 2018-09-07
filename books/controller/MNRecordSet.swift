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
    var tableName=""
    var recordCount=0
    var recordNo = -1
    var isEmpty = true
    private var positionInPage = -1
    private var dataBase : MNDatabase //(path: "")
    var masterRecordset : MNRecordset?
    var masterCol = ""
    var detailCol = ""
    var slaveRecordSet : MNRecordset?
    var slaveKey = ""
    var isSlave = false
    var haveSlave = false
    var field: Dictionary<String, Any> {
        get{ return getField()}
    }
    var sql : String {
        get {
            return "select * from \(tableName) limit \(ofSet),\(limit)"
        }
    }
    
                                                        // implementation
    
    convenience init (database:MNDatabase,record:MNrecord) {
        
        

        self.init(database: database, record: record,SQL : "")
        
    }
    
     init (database : MNDatabase ,record : MNrecord , SQL : String){
        var sql = ""
        tableName = record.getTableName()
        self.dataBase = database

         sql = "select count(id) as recordCount from \(tableName)"
        recordCount = Int(database.getRecords(from: sql, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
        if recordCount > 0 {
            if SQL == "" {
            fields=database.getRecords(of: record, ofset: ofSet, limit: limit)
            } else {
            fields = database.getRecords(from: SQL, ofset: ofSet, limit: limit)
            }

        } else {
            fields = [[String:Any]]()
        }
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
        fields = dataBase.getRecords(from: sql, ofset: ofSet, limit: limit)
    }
    func moveNext()  {
        if !eof() {
            move(to: recordNo+1)
        }
    }
    func movePreior()  {
        if !bof(){
            move(to: recordNo-1)
        }
    }
    func moveFirst()  {
        move(to: 0)
    }
    
    func moveLast()  {
        move(to: recordCount-1)
    }
    func eof() -> Bool {
        return recordNo == recordCount-1
    }
    func bof() -> Bool {
        return recordNo==0
    }
    func getField()->[String:Any] {
        return fields[positionInPage]
    }
    

    func getObject(myRd : MNrecord)-> MNrecord {
        
        //var myRecord : MNrecord
        switch String(describing: type(of: myRd)) {
        case "Book":
            let    myRecord = myRd as! Book
            return recordToObject(myRd: myRecord) as! Book
        case "Men" :
            let    myRecord = myRd as! Men
            return recordToObject(myRd: myRecord) as! Men
        case "BooksList" :
            let    myRecord = myRd as! BooksList
            return recordToObject(myRd: myRecord) as! BooksList
        case "BookIndex" :
            let    myRecord = myRd as! BookIndex
            return recordToObject(myRd: myRecord) as! BookIndex
        case "BookInfo" :
            let    myRecord = myRd as! BookInfo
            return recordToObject(myRd: myRecord) as! BookInfo
        case "BooksCat" :
            let   myRecord = myRd as! BooksCat
            return recordToObject(myRd: myRecord) as! BooksCat
            
        default:
            let  myRecord = myRd
            return recordToObject(myRd: myRecord) as! MNrecord
        }
        
        
        
    }
    
    //*********************
    
    private  func recordToObject<T>(myRd : T) -> AnyObject {
        let fld = getField()
        var myRecord = myRd
        let props = try! properties(myRd)
        // print (props)
        var str = ""
        for i in props.indices {
            str = String(describing: type(of: props[i].value))
            
            //print ("\(String(describing: fld[props[i].key] )) : \(props[i].value)")
            if props[i].key != "ID" {
                // case Property type is String
                if str == "String"  {
                    
                    try! set(fld[props[i].key] ?? "", key: props[i].key, for: &myRecord )
                    
                    // case Property type is Double
                } else if str == "Double"{
                    try! set(fld[props[i].key] ?? -1.0, key: props[i].key, for: &myRecord )
                    // case Property type is Bool
                }else if str == "Bool"{
                    if fld[props[i].key] is Int64 {
                        // sqlite sent 1 instead of true
                        if fld[props[i].key] as! Int64 == 1 {
                            try! set(true, key: props[i].key, for: &myRecord )}else {
                            // sqlite send 0 instead of false
                            try! set(false, key: props[i].key, for: &myRecord )
                        }}
                    else {
                        try! set(fld[props[i].key] ?? false, key: props[i].key, for: &myRecord )
                    }}
                    // case Property type is Int
                else {
                    if fld[props[i].key] != nil &&
                        !(fld[props[i].key] is String) // case Property type is Int but not set , sqlite send empty string
                    {
                        try! set(Int((fld[props[i].key]) as! Int64 ) , key: props[i].key, for: &myRecord )
                    } else {try! set(-1 , key: props[i].key, for: &myRecord )}
                }
            }
            
            
        }
        (myRecord as! MNrecord).ID = Int(fld["ID"] as! Int64)
        return myRecord as AnyObject
    }
    
    
}
