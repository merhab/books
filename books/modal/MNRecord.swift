//
//  MNRecord.swift
//  books
//
//  Created by merhab on 9‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//



import Foundation



class MNrecord  {
static let IDfieldName = "ID"
static let selectedFieldName = "selected"
static let versionFieldName = "version"
static let MNrecordTypeName = "MNrecord"
static let namesExcludeChars = "mn"
    var ID = -1
    var version = 0.0
    var selected  = false
    func isNull()->Bool{
        if ID == -1 {return true}else{return false}
    }
    
     func getTableName() -> String {
        
        return String(describing: type(of: self)).lowercased()
        //let props = try! properties(MNrecord.)
        // return props[props.startIndex].key
        
    }
    
    
    
    func getMNRecordField() -> [Field]  {
        var field : Field
        var fields = [Field]()
        if String(describing: type(of: self)) != MNrecord.MNrecordTypeName {
            field=Field(with: self.ID)
            field.name=MNrecord.IDfieldName
            field.type = MNThawabit.IntTypeName
            fields.append(field)
            field=Field(with: self.selected)
            field.name=MNrecord.selectedFieldName
            field.type=MNThawabit.BoolTypeName
            fields.append(field)
            field=Field(with: self.version)
            field.name=MNrecord.versionFieldName
            field.type=MNThawabit.DoubleTypeName
            fields.append(field)
        }
        return fields
    }
    
    
    func getFields() -> [Field] {
        
        let props = try! properties(self)
        var field : Field
        var fields = [Field]()
        var IDExists = false
        for i in props.indices {
            if !(props[i].key.range(of: MNrecord.namesExcludeChars)?.lowerBound==props[i].key.startIndex){//start with db
                if props[i].key == "ID" {IDExists = true}
                field=Field(with: props[i].value)
                field.type=String(describing:(type(of: props[i].value)))
                field.name=props[i].key
                fields.append(field)
            }
        }
        
        if !IDExists { fields.append(contentsOf:getMNRecordField())}
        //print(fields)
        return fields
        //todo : ID
    }
    
    
    
    
    
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

extension MNrecord : Comparable {
    static func < (lhs: MNrecord, rhs: MNrecord) -> Bool {
        return  (lhs.version < rhs.version )
    }
    
    static func == (lhs: MNrecord, rhs: MNrecord) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    
}



