//
//  DBMNRecord.swift
//  books
//
//  Created by merhab on 8‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation

class DBMNrecord  {
    var database : MNDatabase
    var record : MNrecord
    var isNull : Bool {
        get {
            return record.isNull()
        }
    }
    
    var mnSQLgetWithId : String {
        get {
            var sql = ""
            sql = "select * from \(record.getTableName) where ID = \(record.ID)"
            return sql
        }
    }
    var mnSqlCreate : String {
        get{
            let doubleQuote = """
        "
        """
            var str = ""
            var  props = record.getFields()

            
            for i in props.indices {
                switch props[i].type {
                case  "String" :
                    if str == "" {
                        str = "\(doubleQuote)\(props[i].name)\(doubleQuote) TEXT DEFAULT \(doubleQuote)\(doubleQuote) "
                    } else {
                        str = str + " , \(doubleQuote)\(props[i].name)\(doubleQuote) TEXT DEFAULT \(doubleQuote)\(doubleQuote) "
                    }
                    
                case "Int" :
                    if props[i].name == "ID" {
                        if str == "" {
                            str = "\"ID\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT "
                        } else {
                            str = str + " , \"ID\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT "
                        }
                    }else {
                    if str == "" {
                        str = "\(doubleQuote)\(props[i].name)\(doubleQuote) INTEGER DEFAULT -1 "
                        } else {
                        str = str + " , \(doubleQuote)\(props[i].name)\(doubleQuote) INTEGER DEFAULT -1 "
                        }
                    }
                case "Bool" :
                    if str == "" {
                        str = "\(doubleQuote)\(props[i].name)\(doubleQuote) INTEGER DEFAULT 0 "
                    } else {
                        str = str + " , \(doubleQuote)\(props[i].name)\(doubleQuote) INTEGER DEFAULT 0 "
                    }
                case "Double" :
                    if str == "" {
                        str = "\(doubleQuote)\(props[i].name)\(doubleQuote) REAL DEFAULT -1 "
                    } else {
                        str = str + " , \(doubleQuote)\(props[i].name)\(doubleQuote) REAL DEFAULT -1 "
                    }
                default: break
                    // str = ""
                }
            }
            str = "CREATE TABLE IF NOT EXISTS \(doubleQuote)\(record.getTableName())\(doubleQuote) (" + str + ");"
            
            return str
        }
    }
    
    init (database : MNDatabase , record : MNrecord) {
      self.database = database
      self.record = record
    }
    
    func AddColumnToTabletructure(alterTableSql SQL : String) -> Bool {

        return (database.execute(SQL))

    }
    
    func getTableStructure ()->String{
        
        let str = database.getTableStruct(table: record.getTableName())
        return str
   

    }
    
    
    func updateTableStruct()->Bool {
        var str = ""

            let fields = record.getFields()
            let tblStruct = getTableStructure()
            for i in fields.indices {
                let field = fields[i]
                if !tblStruct.contains(field.name) {
                    if str == "" {
                        str = sqlAddFieldToTableStruct(field: field)
                    }else {
                        str = str + " ; " + sqlAddFieldToTableStruct(field: field)
                    }
                    
                }
            }
            if AddColumnToTabletructure(alterTableSql: str) {
                return true
            } else {
                return false
            }
   
    }

    func insert() -> Bool {
        return save()
    }

    
    func save() -> Bool {
        var str1=""
        var str2=""
        
        for i in record.getFields(){
            if i.name != "ID" {
                if i.type.lowercased() == "string" {
                    if str2==""{
                        str2="'\(i.val)'"
                    }else{
                        str2=str2+",'\(i.val)'"
                        
                    }
                    
                    
                } else if i.type.lowercased() == "bool" {
                    if str2==""{
                        if i.val as! Bool == true { str2="1" } else { str2="0" }
                    }else{
                        if i.val as! Bool == true { str2=str2+",1" } else { str2=str2+",0" }
                        
                        
                    }
                } else {
                    if str2==""{
                        str2="\(i.val)"
                    }else{
                        str2=str2+",\(i.val)"
                        
                    }
                }
                if str1==""{
                    str1=i.name
                }else {
                    str1=str1+","+i.name
                }
                
            }
        }

        let tableName=record.getTableName()
        let sql="INSERT INTO \(tableName) (\(str1)) VALUES(\(str2))"
            let success = database.run(sql: sql)
            record.ID=database.lastInsertRowid
            return success

        
        
        
    }
    
    func saveOrUpdte()->Bool{
        if record.ID == -1{
            return save()
        }else{
            return update()
        }
        
    }
    
    
    // save or update from another dbrecord
    
    func saveOrUpdate(dbRecord : DBMNrecord) -> Bool {

        if dbRecord.isNull {return false}
        else {
            if self.isNull {
                self.record = dbRecord.record
                return self.insert()
                
            }else {
                if self.record > dbRecord.record {
                    self.record = dbRecord.record
                    return self.update()
                }else { return false}

            }
        }

    }
    
    func update()->Bool {
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
        let success =  database.run(sql: sql,bindings: values)
            return success
     
        
    }

    private func sqlAddFieldToTableStruct(field : Field)-> String {
        var str = "ALTER TABLE \(record.getTableName()) ADD "
        switch field.type {
        case  "String" :
            if str == "" {
                str = "\"\(field.name)\" TEXT DEFAULT \"\" "
            } else {
                str = str + "  \"\(field.name)\" TEXT DEFAULT \"\" "
            }
            
        case "Int" :
            if str == "" {
                str = "\"\(field.name)\" INTEGER DEFAULT -1 "
            } else {
                str = str + "  \"\(field.name)\" INTEGER DEFAULT -1 "
            }
        case "Bool" :
            if str == "" {
                str = "\"\(field.name)\" INTEGER DEFAULT 0 "
            } else {
                str = str + "  \"\(field.name)\" INTEGER DEFAULT 0 "
            }
        case "Double" :
            if str == "" {
                str = "\"\(field.name)\" REAL DEFAULT -1 "
            } else {
                str = str + "  \"\(field.name)\" REAL DEFAULT -1 "
            }
        default: break
            // str = ""
        }
        return str
    }
    
    func createTable ()->Bool{
       return database.execute(self.mnSqlCreate)
    }
    
    func getRecordWithId(ID : Int) {
       let flds = database.getRecords(query: "select * from \(record.getTableName()) where ID = \(ID)")
        if flds.count > 0 {
           record = getObject( fld: flds[0])
        }
        
    }
    
    func getFirstRecord(filter close : String){
        var str = ""
        if close == ""
        {
            str = "select * from \(record.getTableName()) limit 1 "
        } else {
            str  = "select * from \(record.getTableName()) where \(close) limit 1 "
        }
        let flds = database.getRecords(query: str)
        if flds.count > 0 {
           record = getObject(fld: flds[0])
        }
    }

    
    //*********************
    func getObject(fld : [String : Any])-> MNrecord {
        //TODO: remove thos from here to dbMNrecord
        
        //var myRecord : MNrecord
        let myRd = record
        switch String(describing: type(of: myRd)  ) {
        case "Book":
            let    myRecord = myRd as! Book
            return recordToObject(myRd: myRecord,fld: fld) as! Book
        case "Men" :
            let    myRecord = myRd as! Men
            return recordToObject(myRd: myRecord,fld: fld) as! Men
        case "BooksList" :
            let    myRecord = myRd as! BooksList
            return recordToObject(myRd: myRecord,fld: fld) as! BooksList
        case "BookIndex" :
            let    myRecord = myRd as! BookIndex
            return recordToObject(myRd: myRecord,fld: fld) as! BookIndex
        case "BooksCat" :
            let   myRecord = myRd as! BooksCat
            return recordToObject(myRd: myRecord,fld: fld) as! BooksCat
            
        default:
            let  myRecord = myRd
            return recordToObject(myRd: myRecord,fld: fld) as! MNrecord
        }
        
        
        
    }
    
    //*********************
    
    private  func recordToObject<T>(myRd : T , fld : [String : Any]) -> AnyObject {
        
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
        (myRecord as! MNrecord).ID = Int(fld["ID"] as? Int64 ?? -1)

        if (Int(fld["selected"] as? Int64 ?? 0)) == 0 {(myRecord as! MNrecord).selected = false } else { (myRecord as! MNrecord).selected = true}
        (myRecord as! MNrecord).version = (fld["version"] as? Double) ?? 0.0
        return myRecord as AnyObject
    }
    
    


    

    

        
        
    

}
