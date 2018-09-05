//
//  MNDatabase.swift
//  books
//
//  Created by merhab on 30‏/8‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
import SQLite
class MNDatabase {
    var database:Connection
    private var path:String=""
    
    init(path:String) {
        self.path=path
        do{ database=try Connection(path)
        }catch{
            self.path=""
          database=try! Connection("") //todo check if file exist and if its a correct sqlite database
        }
    }
    func connect() -> Bool {
        do {
            database = try Connection(path)
            return true
        }
        catch{
            return false
        }
    }
    
    func save(record:MNrecord) -> Bool {
        var values = [String]()
        var str1=""
        var str2=""
        var int=0
        for i in record.getFields(){
            values.append("\(i.val)")
            if str1==""{
                str1=i.name
            }else {
                str1=str1+","+i.name
            }
            if str2==""{
                str2="?\(int)"
            }else{
                str2=str2+",?\(int)"
                
            }
            int+=1
        }
        let tableName=record.getTableName()
        let sql="INSERT INTO \(tableName) (\(str1)) VALUES(\(str2))"
        do {try database.run(sql,values)
            record.ID=Int(database.lastInsertRowid)
            return true
        }
        catch{
         return false
        }
        

        
    }
    func update(record:MNrecord)->Bool {
        var values = [String]()
        var int=0
        var str1=""
        var str2=""
        for i in record.getFields(){
            values.append("\(i.val)")
            str1="\(i.name) = ?\(int)"
            int+=1
            if str2==""{
                str2=str1
            }else{
                str2="\(str2),\(str1)"
            }
            
        }
        let tbl=record.getTableName()
        let sql="update \(tbl) set \(str2) where id=\(record.ID)"
        do{try database.run(sql,values)
            return true
        }
        catch{
            return false
        }
    
    }
    func saveOrUpdte(record:MNrecord)->Bool{
        if record.ID == -1{
            return save(record: record)
        }else{
        return update(record:record)
        }
  
    }
    func getRecords(from sql:String , ofset from:Int,limit records:Int)->[[String:Any]]{
        var field = [String:Any]()
        var fields=[[String:Any]]()
        var sql1=""
        
        if records == -1 {   // is limit = -1 get all records
            sql1 = "\(sql)"
        }else{
           sql1 = " \(sql) limit \(from),\(records)"
        }
        let stmt = try! database.prepare(sql1)
            for row in stmt{
                field.removeAll()
                for (index,name) in stmt.columnNames.enumerated() {
                    if row[index] != nil {
                        field[name] = row[index]
                    }else {field[name] = ""}
                }
                fields.append(field)
            }
            return fields
       
        
    }
    
    func getRecords(of record:MNrecord,ofset from:Int,limit records :Int) ->[[String:Any]] {
       // let stmt = try db.prepare("SELECT id, email FROM users")
        //for row in stmt {
          //  for (index, name) in stmt.columnNames.enumerated() {
            //    print ("\(name):\(row[index]!)")
                // id: Optional(1), email: Optional("alice@mac.com")
           // }
        //}
   
        var sql=""
        let table=record.getTableName()

             sql = "select * from \(table)"
    
     return getRecords(from: sql, ofset: from, limit: records)

    }
}

//*****************


class MNRecordset {
     var field: Dictionary<String, Any> {
        get{ return getField()}
    }
    var sql : String {
        get {
            return "select * from \(tableName) limit \(ofSet),\(limit)"
        }
    }
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
    
    init (database:MNDatabase,record:MNrecord) {
        tableName = record.getTableName()
        self.dataBase = database
        let sql = "select count(id) as recordCount from \(tableName)"
        recordCount = Int(database.getRecords(from: sql, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
        if recordCount > 0 {
        fields=database.getRecords(of: record, ofset: ofSet, limit: limit)
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
