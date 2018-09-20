//
//  Kitab.swift
//  kotobi
//
//  Created by merhab on 19‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//


import Foundation
/**
 super class for DBKitab and DbFahresKalima
 */
class MNKitab {
        var kitabId : Int
        var dataBase : MNDatabase
    init(kitabId : Int , dataBase : MNDatabase){
        self.kitabId = kitabId
        self.dataBase = dataBase
    }
    
 
}
