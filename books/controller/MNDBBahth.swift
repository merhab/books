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
        dbBooksList.filter = " selected = 1 "
        dbBooksList.filtered = true

    }
    func ibhathFiKitab(bahthNass : String , bahth3onwan : String ,kitabId :Int)  {
        let dataBase = MNDatabase(path: MNFile.getDataBasePath(kitabId: kitabId))
   //     DispatchQueue.global(qos: .userInteractive ).async {
            let bahth = MNBahth(bahth: bahthNass, bahthIsm: bahth3onwan)
            //var nataij = [MNNatija]()
            let filter = " where pgText MATCH '\(bahth.getSqlBahth())'"
            let rdsBahth = MNRecordset(database: dataBase,
                                       tableName: KitabFahras.kitabFahrasTableName,
                                       columns: KitabFahras.bahthCols,
                                       whereSql: filter,
                                       orderBy: "rank")
            if !rdsBahth.isEmpty{
                while !rdsBahth.eof(){
                    let dbKitabFahras = DBMNrecord(database: dataBase, record: KitabFahras())
                    dbKitabFahras.record = dbKitabFahras.getObject(fld: rdsBahth.getCurrentRecordAsDictionary()) as! KitabFahras
                    let natija = MNNatija()
                    natija.bahthId = self.bahthId
                    natija.kitab3onwan = self.dbBooksList.getFields()["bkTitle"] as! String
                    natija.kitabId = kitabId
                    natija.rank = rdsBahth.getCurrentRecordAsDictionary()["rank"] as! Double
                    natija.safha = self.dbBooksList.getCurrentKitab().getCurrentSafha().nass
                    natija.safhaId = Int(rdsBahth.getCurrentRecordAsDictionary()["ID"] as! Int64)
                    self.hifdNatija(natija: natija)
//                    nataij.append(natija)
                    rdsBahth.moveNext()
 //               }
                
            }
            
 //           completion (nataij)
            
        }
        
    }
    func ibhathFiKotob(completion:@escaping([MNNatija])->Void?)  {
        hifdBahth()
        let bahth3onwan = bahth.bahthIsm
        let bahthNass = bahth.nassBahth
//        DispatchQueue.global(qos: .userInteractive ).async {

           // var nataij = [MNNatija]()
            if !self.dbBooksList.khawi(){
                self.dbBooksList.awal()
                while !self.dbBooksList.nihaya() {
                    self.ibhathFiKitab(bahthNass: bahthNass, bahth3onwan: bahth3onwan,kitabId:self.dbBooksList.getCurrentKitabId() )
                    self.dbBooksList.lahik()
                    }
                }
                
//            }
        }
    func hifdBahth()  {
        let dbBahth = DBMNrecord(database: MNDatabase(path: MNFile.getBahthDatabasePath()), record: bahth)
        _ = dbBahth.createTable()
        _ = dbBahth.save()
        
        
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
    

