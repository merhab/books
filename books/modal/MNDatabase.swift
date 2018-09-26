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
    var lastInsertRowid : Int {
        get {
            return Int(database.lastInsertRowid)
        }
    }
     var path:String=""
    
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
    
    func execute(_ sql : String) -> Bool {
        do{try database.execute(sql)
            print ("executed 💁‍♂️")
            return true
        }
        catch let error{
            print("cant create table 🤦‍♂️: \(error)")
            return false
        }
    }

    func getRecords (query SQL : String) -> [[String:Any]] {
        var field = [String:Any]()
        var fields=[[String:Any]]()
        do {let stmt = try database.prepare(SQL)
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
        catch {
            return [[String:Any]]()
        }

    }
    
    func getTableStruct (table name :String)-> String{
        
        var str = ""
        let sql = "SELECT sql FROM sqlite_master WHERE tbl_name = '\(name)' AND type = 'table'"
        let stmt = try! database.prepare(sql)
        for row in stmt{
            for (index,_) in stmt.columnNames.enumerated() {
               
                str = (row[index] as! String)
            
                
            }
            
        }
        return str
        
    }
    
    
    func getArrayOfIDs (query SQL :String)->[Int]{
        var array = [Int]()
        let stmt = try! database.prepare(SQL)
        for row in stmt{
            for (index,_) in stmt.columnNames.enumerated() {
                
                if let int64 = (row[index] as? Int64) {
                    array.append(Int(int64))
                }
                if let int = (row[index] as? Int) {
                    array.append(int)
                }
                    //array.append(Int(row[index] as! Int64)-1)

            }

        }
        
        return array
    }
    

    
    func getRecords(query sql:String , ofset from:Int,limit records:Int)->[[String:Any]]{
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
                    }else {field[name] = nil}
                }
                fields.append(field)
            }
            return fields
       
  
    }
    func run (sql : String , _ bindings: Binding?... )-> Bool{
        do {  try
            database.run(sql, bindings)
           // try database.run(sql)
            return true
        }catch let error {
            print("cant run \(sql) \n \(error)")
            return false
        }
        
    }
    func run (sql : String ,bindings:[Binding?] )-> Bool{
        do {  try database.run(sql, bindings)

            return true
        }catch let error {
            print("cant run \(sql) \n \(error)")
            return false
        }
        
    }
    func getRecords(of table:String,ofset from:Int,limit count :Int) ->[[String:Any]] {
       // let stmt = try db.prepare("SELECT id, email FROM users")
        //for row in stmt {
          //  for (index, name) in stmt.columnNames.enumerated() {
            //    print ("\(name):\(row[index]!)")
                // id: Optional(1), email: Optional("alice@mac.com")
           // }
        //}
   
        var sql=""


             sql = "select * from \(table)"
    
     return getRecords(query: sql, ofset: from, limit: count)

    }
    
    static func tableExists ( path : String , table  : String)->Bool{
        if !MNFile.fileExists(path: path){return false}
        let database = MNDatabase(path: path)
        let rds = database.getRecords(query: "SELECT name as tables FROM sqlite_master")
        if !rds.isEmpty  {
            for rd in rds {
                if let tableName = rd["tables"] as? String , tableName == table {
                    
                        return true
                    }
            }
        }
        return false
    }
    
    static func tableIsEmpty ( path : String , table name : String)->Bool{
        if !MNDatabase.tableExists(path: path, table: name) {
            return true
        }
        
      let database = MNDatabase(path: path)
        let rds = database.getRecords(query: "select count(rowid) as recordCount from \(name)")
        if !rds.isEmpty,let count = rds[0]["recordCount"] as? Int64 , count > 0  {
            
            return false
                }
    
            
      
        return true
    }
    
    
}

//*****************


