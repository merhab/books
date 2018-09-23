//
//  DbKalima.swift
//  words
//
//  Created by merhab on 16‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class DBFahresKalimat : MNKitab {



    private var dbKitab : DbKitab
    
    
    init(kitabId: Int) {

        let path = MNFile.getDataBasePath(kitabId: kitabId)
//        _ = MNFile.createFolder(path :path)
//        path = path + "/\(kitabId)\(MNFile.fihresSuffix)"
        let mdataBase = MNDatabase(path: path)
//        _ = DBMNrecord(database: mdataBase, record: MNKalima(text: "")).createTable()
//        _ = DBMNrecord(database: mdataBase, record: MNKalimaTartib(kalima: MNKalima(text: ""))).createTable()
        dbKitab = DbKitab(kitabId: kitabId)
        
        super.init(kitabId: kitabId, dataBase: mdataBase)
        
        
    }
    
   private func getNormalizedKalimatSafha() -> [MNKalima] {
        let nass = dbKitab.getCurrentSafha()
        let kalim = nass.getNormalizedWords()
        var kalimat = [MNKalima]()
        for i in kalim.indices {
            kalimat.append(MNKalima(text: kalim[i], kitabId: dbKitab.kitabId, safhaId: dbKitab.safhaId, tartibInSafha: Double(i)))
        }
        
        return kalimat
    }
   private func fahrasatSafha() {
       let kalimat = getNormalizedKalimatSafha()
        for kalima in kalimat {
            let dbKalima = DBMNrecord(database: dataBase, record:kalima )
            let dbKalimaMinFahres = DBMNrecord(database: dataBase, record: MNKalima(text: ""))
            dbKalimaMinFahres.getFirstRecord(filter: " text = '\(kalima.kalima)'")
            if dbKalimaMinFahres.isNull {
                _ = dbKalima.save()
                let tartibKalima = MNKalimaTartib(kalima: kalima)
                let dbTartibKalima = DBMNrecord(database: dataBase, record: tartibKalima)
                _ = dbTartibKalima.save()
            }else{
                let tartibKalima = MNKalimaTartib(kalima: kalima)
                tartibKalima.idKalima = dbKalimaMinFahres.record.ID
                let dbTartibKalima = DBMNrecord(database: dataBase, record: tartibKalima)
                _ = dbTartibKalima.save()
            }
            
            
            
        }
        
    }
    
    func fahrasatKitab()  {
        _ = dbKitab.dataBase.execute(
            """
            CREATE VIRTUAL TABLE IF NOT EXISTS kitabFahras USING fts5(pgText);
            CREATE TRIGGER IF NOT EXISTS kitabFahrasINSERT AFTER INSERT ON book BEGIN
            INSERT INTO kitabFahras (
            rowid,
            pgText
            )
            VALUES(
            new.id,
            new.pgText
            );
            END;

            -- Trigger on UPDATE
            CREATE TRIGGER IF NOT EXISTS kitabFahrasUpdate UPDATE OF pgText ON book BEGIN
            UPDATE kitabFahras SET pgText = new.pgText WHERE rowid = old.id;
            END;

            -- Trigger on DELETE
            CREATE TRIGGER  IF NOT EXISTS kitabFahrasDelete AFTER DELETE ON book BEGIN
            DELETE FROM kitabFahras WHERE rowid = old.id;
            END;

            """
        )
        if !dbKitab.khawi {
        dbKitab.awal()
        var str = dbKitab.getCurrentSafha().nassNormalized
        _ = dbKitab.dataBase.execute("INSERT INTO kitabFahras(pgText) VALUES  ('\(str)');")

            while !dbKitab.akhirKitab {
                dbKitab.lahik()
                str = dbKitab.getCurrentSafha().nassNormalized
              _ = dbKitab.dataBase.execute("INSERT INTO kitabFahras(pgText) VALUES  ('\(str)');")


            }
            
        }

        
    }
    
    
    
}
