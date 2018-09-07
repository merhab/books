//
//  MNDatabase.swift
//  books
//
//  Created by merhab on 30‏/8‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
//import SQLite
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
    func execute(_ sql : String) -> Bool {
        do{try database.execute(sql)
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
    func getRecords (query SQL : String) -> [[String:Any]] {
        var field = [String:Any]()
        var fields=[[String:Any]]()
        let stmt = try! database.prepare(SQL)
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


