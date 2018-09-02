//
//  MNRecord.swift
//  books
//
//  Created by merhab on 28‏/8‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
import SQLite


class MNrecord  {
    var ID = -1

    
    func getTableName() -> String {
    
            return String(describing: type(of: self)).lowercased()
        //let props = try! properties(MNrecord.)
            // return props[props.startIndex].key

    }
    func getObject(field : [String:Any]) {
            let fld = field
          
            let props = try! properties(self)
            print (props)
            var rd = self
            
            var str = ""
            for i in props.indices {
                str = String(describing: type(of: props[i].value))
                
                print ("\(props[i].key) : \(props[i].value)")
                if str == "String"{
                    
                    try! set(fld[props[i].key] ?? "", key: props[i].key, for: &rd )
                } else {
                    try! set(fld[props[i].key] ?? -1, key: props[i].key, for: &rd )
                }
            }
            print (rd)
            
        }
        
      
    

    
    func getFields() -> [Field] {
        let props = try! properties(self)
        var field : Field
        var fields = [Field]()
        for i in props.indices {
            if !(props[i].key.range(of: "mn")?.lowerBound==props[i].key.startIndex){//start with db
            field=Field(with: props[i].value)
                field.type=String(describing:(type(of: self)))
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
