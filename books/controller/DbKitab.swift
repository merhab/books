//
//  DbKitab.swift
//  books
//
//  Created by merhab on 16‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class DbKitab {
    var rdsKitab : MNRecordset
    var dbSafha : DBMNrecord
    var dbKitabParam : DBMNrecord
    var currentSafha : Nass
    var dataBase : MNDatabase
    var kitabId : Int
    
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
            currentSafha = Nass(nass: "", kalimaBidaya: Kalima(kalima: ""))
        } else {
            //TODO: getObject nee redesign
           dbSafha.getRecordWithId(ID:Int(rdsKitab.getField()["ID"] as! Int64) )
            let safha = dbSafha.record as! Book
            let words = Nass.getWords(text: safha.pgText)
            let kalima = Kalima(kalima: words[0], kitabId: kitabId, safhaId: safha.ID, tartibInSafha: 0)
            currentSafha = Nass(nass: safha.pgText, kalimaBidaya: kalima)
  
            

        }
        
    }
    
    func getCurrentSafha()  {
         dbSafha.getRecordWithId(ID:Int(rdsKitab.getField()["ID"] as! Int64) )
        let safha = dbSafha.record as! Book
        let words = Nass.getWords(text: safha.pgText)
        let kalima = Kalima(kalima: words[0], kitabId: kitabId, safhaId: safha.ID, tartibInSafha: 0)
        currentSafha = Nass(nass: safha.pgText, kalimaBidaya: kalima)

        
    }
}
