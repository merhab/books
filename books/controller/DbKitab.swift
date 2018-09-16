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
     rdsKitab = MNRecordset(database: dataBase, table: dbSafha.tableName)
    dbKitabParam = DBMNrecord(database: dataBase, record: MNrecordParams())
        _ = dbKitabParam.createTable()
        if rdsKitab.isEmpty {
            currentSafha = Nass()
        } else {
            //TODO: getObject nee redesign
           dbSafha.getRecordWithId(ID:rdsKitab.getField()["ID"] as! Int )
            let safha = dbSafha.record as! Book
            let words = Nass.getWords(text: safha.pgText)
            let kalima1 = Kalima(kalima: words[0], kalimaId: KalimaIdentificator(ID: -1, kitabId: kitabId, safhaId: safha.ID, tartibInSafha: 0))
            let kalima2 = Kalima(kalima: words[words.count-1], kalimaId: KalimaIdentificator(ID: -1, kitabId: kitabId, safhaId: safha.ID, tartibInSafha: Double(words.count-1)))
            currentSafha = Nass(nass: safha.pgText, nassIdentificator: NassIdentificator(ID: -1, kitabID: kitabId, kalimaBidaya: kalima1, kalimaNihaya: kalima2))
  
            

        }
        
    }
    
    func getCurrentSafha()  {
         dbSafha.getRecordWithId(ID:rdsKitab.getField()["ID"] as! Int )
        let safha = dbSafha.record as! Book
        let words = Nass.getWords(text: safha.pgText)
        let kalima1 = Kalima(kalima: words[0], kalimaId: KalimaIdentificator(ID: -1, kitabId: kitabId, safhaId: safha.ID, tartibInSafha: 0))
        let kalima2 = Kalima(kalima: words[words.count-1], kalimaId: KalimaIdentificator(ID: -1, kitabId: kitabId, safhaId: safha.ID, tartibInSafha: Double(words.count-1)))
        currentSafha = Nass(nass: safha.pgText, nassIdentificator: NassIdentificator(ID: -1, kitabID: kitabId, kalimaBidaya: kalima1, kalimaNihaya: kalima2))
        
    }
}
