//
//  DbKalima.swift
//  words
//
//  Created by merhab on 16‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class DBFahresKalimat : Kitab {



    private var dbKitab : DbKitab
    
    
    init(kitabId: Int) {

        var path = MNFile.getDocFolder()+"/\(MNFile.booksFolderName)/\(MNFile.fihrasFolderName)"
        _ = MNFile.createFolder(path :path)
        path = path + "/\(kitabId)\(MNFile.fihresSuffix)"
        let mdataBase = MNDatabase(path: path)
        _ = DBMNrecord(database: mdataBase, record: Kalima(text: "")).createTable()
        _ = DBMNrecord(database: mdataBase, record: KalimaTartib(kalima: Kalima(text: ""))).createTable()
        dbKitab = DbKitab(kitabId: kitabId)
        
        super.init(kitabId: kitabId, dataBase: mdataBase)
        
        
    }
    
   private func getNormalizedKalimatSafha() -> [Kalima] {
        let nass = dbKitab.getCurrentSafha()
        let kalim = nass.getNormalizedWords()
        var kalimat = [Kalima]()
        for i in kalim.indices {
            kalimat.append(Kalima(text: kalim[i], kitabId: dbKitab.kitabId, safhaId: dbKitab.safhaId, tartibInSafha: Double(i)))
        }
        
        return kalimat
    }
   private func fahrasatSafha() {
       let kalimat = getNormalizedKalimatSafha()
        for kalima in kalimat {
            let dbKalima = DBMNrecord(database: dataBase, record:kalima )
            let dbKalimaMinFahres = DBMNrecord(database: dataBase, record: Kalima(text: ""))
            dbKalimaMinFahres.getFirstRecord(filter: " text = '\(kalima.kalima)'")
            if dbKalimaMinFahres.isNull {
                _ = dbKalima.save()
                let tartibKalima = KalimaTartib(kalima: kalima)
                let dbTartibKalima = DBMNrecord(database: dataBase, record: tartibKalima)
                _ = dbTartibKalima.save()
            }else{
                let tartibKalima = KalimaTartib(kalima: kalima)
                tartibKalima.idKalima = dbKalimaMinFahres.record.ID
                let dbTartibKalima = DBMNrecord(database: dataBase, record: tartibKalima)
                _ = dbTartibKalima.save()
            }
            
            
            
        }
        
    }
    
    func fahrasatKitab()  {
        if !dbKitab.khawi {
        dbKitab.awal()
        fahrasatSafha()
        dbKitab.compressSafha() 
            while !dbKitab.akhirKitab {
                dbKitab.lahik()
                fahrasatSafha()
                dbKitab.compressSafha()
            }
            
        }

        
    }
    
    
    
}
