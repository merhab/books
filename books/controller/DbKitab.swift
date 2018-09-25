//
//  DbKitab.swift
//  books
//
//  Created by merhab on 16‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class DbKitab : MNKitab{
    let kitabFahrasTableName = DBFahresKalimat.fahrasTableName

   private var rdsKitab : MNRecordset
    private var dbSafha : DBMNrecord
    var dbKitabParam : DBMNrecord
    private var currentSafha : MNNass
    var nass :  String {return currentSafha.nass }
    var khawi : Bool  {return rdsKitab.isEmpty }
    var nihaya : Bool {return rdsKitab.eof()}
    var bidaya : Bool {return rdsKitab.eof()}
    var safhaId : Int {return dbSafha.record.ID}
    
    init(kitabId : Int) {
     let path = MNFile.getDataBasePath(kitabId: kitabId)
     let mdataBase = MNDatabase(path: path)
     dbSafha = DBMNrecord(database: mdataBase, record: Book())
     _ = dbSafha.updateTableStruct()
     rdsKitab = MNRecordset(database: mdataBase, table: dbSafha.tableName)
     dbKitabParam = DBMNrecord(database: mdataBase, record: MNrecordParams())
        _ = dbKitabParam.createTable()
        if rdsKitab.isEmpty {
            currentSafha = MNNass(nass: "", kalimaBidaya: MNKalima(text: ""))
        } else {
            //TODO: getObject need redesign
           dbSafha.getRecordWithId(ID:Int(rdsKitab.getCurrentRecordAsDictionary()["ID"] as! Int64) )
            let safha = dbSafha.record as! Book
            let words = MNNass.getWords(text: safha.pgText)
            let kalima = MNKalima(text: words[0], kitabId: kitabId, safhaId: safha.ID, tartibInSafha: 0)
            currentSafha = MNNass(nass: safha.pgText, kalimaBidaya: kalima)
        }
              super.init(kitabId: kitabId, dataBase: mdataBase)
    }
    
    func getCurrentSafha()->MNNass  {
         dbSafha.getRecordWithId(ID:Int(rdsKitab.getCurrentRecordAsDictionary()["ID"] as! Int64) )
        let safha = dbSafha.record as! Book
        let words = MNNass.getWords(text: safha.pgText)
        let kalima = MNKalima(text: words[0], kitabId: kitabId, safhaId: safha.ID, tartibInSafha: 0)
        currentSafha = MNNass(nass: safha.pgText, kalimaBidaya: kalima)
        return currentSafha

        
    }
//    func compressSafha()  {
//        dbSafha.getRecordWithId(ID:Int(rdsKitab.getField()["ID"] as! Int64) )
//        if let safha = dbSafha.record as? Book {
//        safha.pgText = MNNass.compress(text: safha.pgText)
//            if safha.ID != -1 {
//                _ = dbSafha.update()
//            }
//        }
//    }
    
//    func readCompressedSafha() -> String {
//        dbSafha.getRecordWithId(ID:Int(rdsKitab.getField()["ID"] as! Int64) )
//        if let safha = dbSafha.record as? Book {
//            return MNNass.deCompress(textBase64: safha.pgText)
//
//        }else {
//            return ""
//        }
//    }
    
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
