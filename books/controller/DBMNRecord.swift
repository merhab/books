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
    var tableName : String {
        get{
            return record.getTableName()
        }
    }
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
            var str2 = ""
            var  props = record.getFields()

            
            for i in props.indices {
                switch props[i].type {
                case  "String" :
                    if str == "" {
                        str = "\(doubleQuote)\(props[i].name)\(doubleQuote) TEXT DEFAULT \(doubleQuote)\(doubleQuote) "
                    } else {
                        str = str + " , \(doubleQuote)\(props[i].name)\(doubleQuote) TEXT DEFAULT \(doubleQuote)\(doubleQuote) "
                    }
                    if str2 == "" {
                       str2 = " CREATE INDEX IF NOT EXISTS \(props[i].name)Ind ON \(tableName) (\(props[i].name)) ;"
                    }else {
                        str2 = str2 + " CREATE INDEX IF NOT EXISTS \(props[i].name)Ind ON \(tableName) (\(props[i].name)) ;"

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
            str = "CREATE TABLE IF NOT EXISTS \(doubleQuote)\(record.getTableName())\(doubleQuote) (" + str + ") ; " + str2
            
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

 

    
    func save() -> Bool {
        var str1=""
        var str2=""
        
        for i in record.getFields(){
        if !i.name.contains("mn") {
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
        }}

        let tableName=record.getTableName()
        let sql="INSERT INTO \(tableName) (\(str1)) VALUES(\(str2))"
            let success = database.run(sql: sql)
        if success {
            record.ID=database.lastInsertRowid
        }
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
                return self.save()
                
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
        var int=1
        var str1=""
        var str2=""
        for i in record.getFields(){
            switch i.type {
                case "String":
                values.append("'\(i.val)'")
                case "Bool":
                    if (i.val as! Bool) == true {
                        values.append("1")
                    }else {
                        values.append("0")
                }
                
                default:
                values.append("\(i.val)")
            }
            //values.append("\(i.val)")
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
        if success {
            print("\(record.ID) : updated 💁‍♂️")
        }else {print("\(record.ID) : not updted 🤦‍♂️")}
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
    /**
     get one record from database with the given filter
        - Parameters:
            - close: the Where condition without 'Where' keyword
     */
    
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
        //TODO: getObject nee redesign
        
        //var myRecord : MNrecord
        let myRd = record
        switch String(describing: type(of: myRd)  ) {
        case MNThawabit.BookTypeName:
            let    myRecord = myRd as! Book
            return recordToObject(myRd: myRecord,fld: fld) as! Book
        case MNThawabit.MenTypeName :
            let    myRecord = myRd as! Men
            return recordToObject(myRd: myRecord,fld: fld) as! Men
        case MNThawabit.BooksListTypeName :
            let    myRecord = myRd as! BooksList
            return recordToObject(myRd: myRecord,fld: fld) as! BooksList
        case MNThawabit.BookIndexTypeName :
            let    myRecord = myRd as! BookIndex
            return recordToObject(myRd: myRecord,fld: fld) as! BookIndex
        case MNThawabit.BooksCatTypeName :
            let   myRecord = myRd as! BooksCat
            return recordToObject(myRd: myRecord,fld: fld) as! BooksCat
        case MNThawabit.MNKalimaTypeName :
            let   myRecord = myRd as! MNKalima
            return recordToObject(myRd: myRecord,fld: fld) as! MNKalima
        case MNThawabit.MNKalimaTartibTypeName :
            let   myRecord = myRd as! MNKalimaTartib
            return recordToObject(myRd: myRecord,fld: fld) as! MNKalimaTartib
        case MNThawabit.MNKalimaDescriptionTypeName :
            let   myRecord = myRd as! MNKalimaDescription
            return recordToObject(myRd: myRecord,fld: fld) as! MNKalimaDescription
            
        case MNThawabit.MNrecordParamsTypeName :
            let   myRecord = myRd as! MNrecordParams
            return recordToObject(myRd: myRecord,fld: fld) as! MNrecordParams
        case MNThawabit.MNNassTypeName :
            let   myRecord = myRd as! MNNass
            return recordToObject(myRd: myRecord,fld: fld) as! MNNass
        case MNThawabit.MNBahthTypeName :
            let   myRecord = myRd as! MNBahth
            return recordToObject(myRd: myRecord,fld: fld) as! MNBahth
//        case MNThawabit.MNBahthFiTypeName :
//            let   myRecord = myRd as! MNBahthFi
//            return recordToObject(myRd: myRecord,fld: fld) as! MNBahthFi
        case MNThawabit.MNBahthNatijaTypeName :
            let   myRecord = myRd as! KitabFahras
            return recordToObject(myRd: myRecord,fld: fld) as! KitabFahras
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
            if !props[i].key.contains("mn") {
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
                        try! set(fld[props[i].key] ?? false, key: props[i].key, for: &myRecord  )
                    }}
                    // case Property type is Int
                else {
                    if fld[props[i].key] != nil &&
                        !(fld[props[i].key] is String) // case Property type is Int but not set , sqlite send empty string
                    {
                        try! set(Int((fld[props[i].key]) as! Int64 ) , key: props[i].key, for: &myRecord )
                    } else {
                        try! set(-1 , key: props[i].key, for: &myRecord )
                        
                    }
                }
            }
            
            
        }}
        (myRecord as! MNrecord).ID = Int(fld["ID"] as? Int64 ?? -1)

        if (Int(fld["selected"] as? Int64 ?? 0)) == 0 {(myRecord as! MNrecord).selected = false } else { (myRecord as! MNrecord).selected = true}
        (myRecord as! MNrecord).version = (fld["version"] as? Double) ?? 0.0
        return myRecord as AnyObject
    }
    
    


    

    

        
        
    

}
