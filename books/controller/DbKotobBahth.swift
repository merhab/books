//
//  DbKotobBahth.swift
//  books
//
//  Created by merhab on 24‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class DbKotobBahth {
    let kitabFahres = "kitabFahras"
    var kotobList : [Int]
    var bahth : MNBahth
    init(kotobList:[Int],bahth3onwan : String , bahthNass : String) {
        self.kotobList = kotobList
        bahth = MNBahth(bahth: bahthNass, bahthIsm: bahth3onwan)
    }
    
    func ibhath()->[MNNatija]{
        let nataij = [MNNatija]()
        if !kotobList.isEmpty{
            for kitabId in kotobList {
                
                let database = MNDatabase(path: MNFile.getDataBasePath(kitabId: kitabId))
                let rdsKitab  = MNRecordset(database: database, tableName: kitabFahres, whereSql: " pgText MATCH '\(bahth.getSqlBahth())'", orderBy: "rank")
                if !rdsKitab.isEmpty {
                    let natija = MNNatija()
                    natija.kitabId = kitabId
                    natija.safhaId = -1
                    
                }
            }
        }
        
        return nataij
    }
}
