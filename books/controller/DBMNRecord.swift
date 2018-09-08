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
            let props = record.getFields()
            for i in props.indices {
                switch props[i].type {
                case  "String" :
                    if str == "" {
                        str = "\(doubleQuote)\(props[i].name)\(doubleQuote) TEXT DEFAULT \(doubleQuote)\(doubleQuote) "
                    } else {
                        str = str + " , \(doubleQuote)\(props[i].name)\(doubleQuote) TEXT DEFAULT \(doubleQuote)\(doubleQuote) "
                    }
                    
                case "Int" :
                    if str == "" {
                        str = "\(doubleQuote)\(props[i].name)\(doubleQuote) INTEGER DEFAULT -1 "
                    } else {
                        str = str + " , \(doubleQuote)\(props[i].name)\(doubleQuote) INTEGER DEFAULT -1 "
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
    
    func CheckColInTableStructure (field name:String)->Bool{
        
        let str = database.getTableStruct(table: record.getTableName())
        if str.index(of: name) != nil {
            //let domains = str.prefix(upTo: index)
            //print(domains)  // "ab\n"
            return true
        } else {return false}
   

    }
    
    
    func updateTableStruct()->Bool {
        var str = ""

            let fields = record.getFields()
            for i in fields.indices {
                let field = fields[i]
                if CheckColInTableStructure(field: field.name) {
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
        return database.save(record: record)
    }
    func update() -> Bool {
        return database.update(record: record)
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
           record = getObject(myRd: record, fld: flds[0])
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
           record = getObject(myRd :record ,fld: flds[0])
        }
    }

    
    //*********************
    func getObject(myRd : MNrecord,fld : [String : Any])-> MNrecord {
        //TODO: remove thos from here to dbMNrecord
        
        //var myRecord : MNrecord
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
        (myRecord as! MNrecord).ID = Int(fld["ID"] as! Int64)
        (myRecord as! MNrecord).ID = Int(fld["ID"] as! Int64)
        if (Int(fld["selected"] as! Int64)) == 0 {(myRecord as! MNrecord).selected = false } else { (myRecord as! MNrecord).selected = true}
        (myRecord as! MNrecord).version = (fld["version"] as? Double) ?? 0.0
        return myRecord as AnyObject
    }
    
    


    

    

        
        
    

}
