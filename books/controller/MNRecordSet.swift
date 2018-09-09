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
    var tableName : String
    var recordCount : Int
    var recordNo : Int
    var isEmpty = true
    var database : MNDatabase
    private var positionInPage : Int
    private var dataBase : MNDatabase //(path: "")
    var range : MNRecordSetRange
    var field: Dictionary<String, Any> {
        get{ return getField()}
    }
   private var sql : String {
        get {
            return "select * from \(tableName) "
        }
    }
    var filter = "" // the where sql close without the where
    var filtered = false {
        didSet {
            if filtered  {
            let sqlFilter = "select ID from \(tableName) where  \(filter)"
            let myRange = database.getArrayOfIDs(query: sqlFilter)
                range=MNRecordSetRange(array: myRange)
                if let _ = myRange.index(of: recordNo)  {
                range.position = recordNo
                range.arrayPosition = range.array.index(of: recordNo)!
                }else {
                moveFirst()
                }
            }else{
              range = MNRecordSetRange(min: 0, max: recordCount-1)
                range.position = recordNo
            }
        }
    }
    
                                                        // implementation
    
    convenience init (database:MNDatabase,table:String) {
        
        
        self.init(database: database, tableName: table, SQL: "")
        
    }
    
     init (database : MNDatabase ,tableName : String , SQL : String){
        self.database = database
        self.tableName = tableName
        range = MNRecordSetRange(min: -1,max: -1)
        var sql = ""

        self.dataBase = database

         sql = "select count(id) as recordCount from \(tableName)"
        recordCount = Int(database.getRecords(from: sql, ofset: -1, limit: -1)[0]["recordCount"] as! Int64)
        if recordCount > 0
        {
            range.min=0
            range.max=recordCount-1

            if SQL == ""{fields=database.getRecords(of: tableName, ofset: ofSet, limit: limit)}
            else{fields = database.getRecords(from: SQL, ofset: ofSet, limit: limit)}
        } else {fields = [[String:Any]]()}
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
            move(to: range.nextPosition())
        }
    }
    func movePreior()  {
        if !bof(){
            move(to: range.priorPosition())
        }
    }
    func moveFirst()  {
        move(to: range.firstPosition())
    }
    
    func moveLast()  {
        
        move(to: range.lastPosition())
    }
    func eof() -> Bool {
        return range.isEnd()
    }
    func bof() -> Bool {
        return range.isStart()
    }
    func getField()->[String:Any] {
        return fields[positionInPage]
    }
    

//    func getObject(myRd : MNrecord)-> MNrecord {
//
//       return DBMNrecord(database: database, record: myRd).getObject( fld: getField())
//
//        
//        
//    }
    
    //*********************
    

    
    
}

// *********************************
//a classe to make range of index for the record set]
// to make it easy to filter the rocord set

struct MNRecordSetRange {
    var position : Int
    var max : Int
    var min : Int
    var hasRange : Bool
    var array = [Int]()
    fileprivate var arrayPosition = -1
    init (min : Int,max :Int){
        self.min=min
        self.max=max
        position = min
        hasRange = false
    }
    init(array:[Int]) {
        if array.count != 0 {
        min=array[0]
        max=array[array.count-1]
        position = min
        hasRange=true
        arrayPosition=0
        self.array=array
        }else
        {
            hasRange = false
            max = -1
            min = -1
            position = -1
        }
        
 
    }

    
    func isEnd() -> Bool {
        return (position == max)
    }
    func isStart() -> Bool {
        return (position == min)
    }
   mutating func firstPosition()->Int {
        if hasRange {
            position = array[0]
            arrayPosition=0
        }else{
            position = min
    }
        
        return position
    }
    
    mutating func lastPosition() -> Int {
        if hasRange {
            position = array[array.count-1]
            arrayPosition=array.count-1
        }else{
            position = max
        }
        
        return position
    }
    
    mutating func nextPosition()->Int{
        if !isEnd(){
        if hasRange {
            position = array[arrayPosition+1]
            arrayPosition+=1
        }else{
            position += 1
        }
        }
        return position
    }
    
    mutating func priorPosition()->Int{
        if !isStart(){
            if hasRange {
                position = array[arrayPosition-1]
                arrayPosition-=1
            }else{
                position -= 1
            }
        }
        return position
    }
    
}

