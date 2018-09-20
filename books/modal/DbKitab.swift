//
//  DbKitab.swift
//  books
//
//  Created by merhab on 16‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class DbKitab {
   private var rdsKitab : MNRecordset
    private var dbSafha : DBMNrecord
    var dbKitabParam : DBMNrecord
    private var currentSafha : Nass
    var dataBase : MNDatabase
    var khawi : Bool {
        get{
            return rdsKitab.isEmpty
        }
    }
    var akhirKitab : Bool{
        get {
            return rdsKitab.eof()
        }
    }
    var awalKitab : Bool {
        get{
            return rdsKitab.eof()
        }
    }
    var kitabId : Int
    var safhaId : Int {
        get{
            return dbSafha.record.ID
        }
    }
    
    init(kitabId : Int) {
    self.kitabId = kitabId
    let path = MNFile.getDataBasePath(kitabId: kitabId)
     dataBase = MNDatabase(path: path)
     dbSafha = DBMNrecord(database: dataBase, record: Book())
     _ = dbSafha.updateTableStruct()
     rdsKitab = MNRecordset(database: dataBase, table: dbSafha.tableName)
    dbKitabParam = DBMNrecord(database: dataBase, record: MNrecordParams())
        _ = dbKitabParam.createTable()
        if rdsKitab.isEmpty {
            currentSafha = Nass(nass: "", kalimaBidaya: MNKalima(text: ""))
        } else {
            //TODO: getObject nee redesign
           dbSafha.getRecordWithId(ID:Int(rdsKitab.getField()["ID"] as! Int64) )
            let safha = dbSafha.record as! Book
            let words = Nass.getWords(text: safha.pgText)
            let kalima = MNKalima(text: words[0], kitabId: kitabId, safhaId: safha.ID, tartibInSafha: 0)
            currentSafha = Nass(nass: safha.pgText, kalimaBidaya: kalima)
  
            

        }
        
    }
    
    func getCurrentSafha()->Nass  {
         dbSafha.getRecordWithId(ID:Int(rdsKitab.getField()["ID"] as! Int64) )
        let safha = dbSafha.record as! Book
        let words = Nass.getWords(text: safha.pgText)
        let kalima = MNKalima(text: words[0], kitabId: kitabId, safhaId: safha.ID, tartibInSafha: 0)
        currentSafha = Nass(nass: safha.pgText, kalimaBidaya: kalima)
        return currentSafha

        
    }
    
    func awal()   {
        rdsKitab.moveFirst()
    }
    func akhir()  {
        rdsKitab.moveLast()
    }
    func sabik()  {
        rdsKitab.movePreior()
    }
    func lahik()  {
        rdsKitab.moveNext()
    }
    func idhab(ila position:Int)  {
        rdsKitab.move(to: position)
    }
    

}
