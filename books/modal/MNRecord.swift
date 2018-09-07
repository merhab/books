//
//  MNRecord.swift
//  books
//
//  Created by merhab on 28‏/8‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
//import SQLite


class MNrecord  {
    var ID = -1
    var mnSQLgetWithId : String {
        get {
            var sql = ""
            sql = "select * from \(getTableName) where ID = \(ID)"
            return sql
        }
    }
      var mnSqlCreate : String {
        get{
        let doubleQuote = """
        "
        """
            var str = ""
            let props = getFields()
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
            str = "CREATE TABLE IF NOT EXISTS \(doubleQuote)\(getTableName())\(doubleQuote) (" + str + ");"
            
           return str
        }

    }

    func isNull()->Bool{
        if ID == -1 {return true}else{return false}
    }
    func getTableName() -> String {
    
            return String(describing: type(of: self)).lowercased()
        //let props = try! properties(MNrecord.)
            // return props[props.startIndex].key

    }

    
      
    

    
     func getFields() -> [Field] {
        let props = try! properties(self)
        var field : Field
        var fields = [Field]()
        for i in props.indices {
            if !(props[i].key.range(of: "mn")?.lowerBound==props[i].key.startIndex){//start with db
            field=Field(with: props[i].value)
                field.type=String(describing:(type(of: props[i].value)))
            field.name=props[i].key
            fields.append(field)
            }
            }
        //print(fields)
        return fields
        //todo : ID
    }
    

    

    
}
//*********************
enum Auto {
    case integer(Expression<Int64>)
    case string(Expression<String>)
    case double(Expression<Double>)
    case boolean(Expression<Bool>)
}
//********************
class Field {
    var name : String = ""
    var type : String = ""
    var val : Any
    init(with val:Any)
    {
        self.val=val
    }
 
}
