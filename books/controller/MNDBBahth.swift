//
//  MNDBBahth.swift
//  kotobi
//
//  Created by merhab on 20‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class MNDBBAhth {
    var bahth : MNBahth
    var bahthNatija = [MNNatija]()
    var rdsBahth : MNRecordset?
    var bahthId = -1
    let dbBooksList = DBBooksList()
    
    init(bahthJomla : String , bahthIsm : String = "" ) {
        bahth = MNBahth(bahth: bahthJomla, bahthIsm: bahthIsm)


    }
    func ibhathFiKitab(kitabId :Int)  {
        let dataBase = MNDatabase(path: MNFile.getDataBasePath(kitabId: kitabId))
   //     DispatchQueue.global(qos: .userInteractive ).async {
            //var nataij = [MNNatija]()
            let filter = "  pgText MATCH '\(bahth.getSqlBahth())'"
            let rdsBahth = MNRecordset(database: dataBase,
                                       tableName: KitabFahras.kitabFahrasTableName,
                                       columns: KitabFahras.bahthCols,
                                       whereSql: filter,
                                       orderBy: "rank")
            if !rdsBahth.isEmpty{
                while !rdsBahth.eof(){
                    let kitabFahres = KitabFahras()
                    let dic = rdsBahth.getCurrentRecordAsDictionary()
                    kitabFahres.rank = dic["rank"] as? Double ?? 0
                    kitabFahres.ID = Int(dic["ID"] as? Int64 ?? -1)
                    kitabFahres.selected = false
                    kitabFahres.version = 0
                    let natija = MNNatija()
                    natija.bahthId = self.bahth.ID
                    natija.kitab3onwan = self.dbBooksList.getFields()["bkTitle"] as! String
                    natija.kitabId = kitabId
                    natija.rank = kitabFahres.rank
                    natija.safha = self.dbBooksList.getCurrentKitab().getSafhaWithId(safhaId: kitabFahres.ID ).nass
                    natija.safhaId = kitabFahres.ID
                    self.hifdNatija(natija: natija)
//                    nataij.append(natija)
                    rdsBahth.moveNext()
 //               }
                
            }
            
 //           completion (nataij)
            
        }
        
    }
    func ibhathFiKotob(completion:@escaping([MNNatija])->Void?)  {
        dbBooksList.filter(filter: " selected = 1 ")
        dbBooksList.filtered( filtered: true)
        if !dbBooksList.khawi(){
        hifdBahth()
//        DispatchQueue.global(qos: .userInteractive ).async {

           // var nataij = [MNNatija]()

                self.dbBooksList.awal()
                while !self.dbBooksList.nihaya() {
                    self.ibhathFiKitab(kitabId:self.dbBooksList.getCurrentKitabId() )
                    self.dbBooksList.lahik()
                    }
            
                
//            }
        }
        }
    func hifdBahth()  {
        let dbBahth = DBMNrecord(database: MNDatabase(path: MNFile.getBahthDatabasePath()), record: bahth)
        _ = dbBahth.createTable()
        _ = dbBahth.save()
        bahthId = bahth.ID
        
    }
    func hifdNatija(natija : MNNatija)  {
        let dbNatija = DBMNrecord(database: MNDatabase(path: MNFile.getBahthDatabasePath()), record: natija)
        _ = dbNatija.createTable()
        _ = dbNatija.save()

    }
    
    func hadfBahth()  {
        let dataBase = MNDatabase(path: MNFile.getBahthDatabasePath())
        _ = dataBase.execute("delete * from MNNatija where bahthId = \(bahth.ID) ")
        _ = dataBase.execute("delete * from MNBahth where ID = \(bahth.ID)")
        
    }
    }
    

