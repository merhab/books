//
//  DbKitab.swift
//  books
//
//  Created by merhab on 16‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class DbKitab : Kitab{
   private var rdsKitab : MNRecordset
    private var dbSafha : DBMNrecord
    var dbKitabParam : DBMNrecord
    private var currentSafha : Nass
    var nass : String {
        get {
            return readCompressedSafha()
        }
    }

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

    var safhaId : Int {
        get{
            return dbSafha.record.ID
        }
    }
    
    init(kitabId : Int) {
  
    
    let path = MNFile.getDataBasePath(kitabId: kitabId)
     let mdataBase = MNDatabase(path: path)
     dbSafha = DBMNrecord(database: mdataBase, record: Book())
     _ = dbSafha.updateTableStruct()
     rdsKitab = MNRecordset(database: mdataBase, table: dbSafha.tableName)
    dbKitabParam = DBMNrecord(database: mdataBase, record: MNrecordParams())
        _ = dbKitabParam.createTable()
        if rdsKitab.isEmpty {
            currentSafha = Nass(nass: "", kalimaBidaya: Kalima(text: ""))
        } else {
            //TODO: getObject need redesign
           dbSafha.getRecordWithId(ID:Int(rdsKitab.getField()["ID"] as! Int64) )
            let safha = dbSafha.record as! Book
            let words = Nass.getWords(text: safha.pgText)
            let kalima = Kalima(text: words[0], kitabId: kitabId, safhaId: safha.ID, tartibInSafha: 0)
            currentSafha = Nass(nass: safha.pgText, kalimaBidaya: kalima)
  


        }
              super.init(kitabId: kitabId, dataBase: mdataBase)
    }
    
    func getCurrentSafha()->Nass  {
         dbSafha.getRecordWithId(ID:Int(rdsKitab.getField()["ID"] as! Int64) )
        let safha = dbSafha.record as! Book
        let words = Nass.getWords(text: safha.pgText)
        let kalima = Kalima(text: words[0], kitabId: kitabId, safhaId: safha.ID, tartibInSafha: 0)
        currentSafha = Nass(nass: safha.pgText, kalimaBidaya: kalima)
        return currentSafha

        
    }
    func compressSafha()  {
        dbSafha.getRecordWithId(ID:Int(rdsKitab.getField()["ID"] as! Int64) )
        if let safha = dbSafha.record as? Book {
        safha.pgText = Nass.compress(text: safha.pgText)
            if safha.ID != -1 {
                _ = dbSafha.update()
            }
        }
    }
    
    func readCompressedSafha() -> String {
        dbSafha.getRecordWithId(ID:Int(rdsKitab.getField()["ID"] as! Int64) )
        if let safha = dbSafha.record as? Book {
            return Nass.deCompress(textBase64: safha.pgText)

        }else {
            return ""
        }
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
