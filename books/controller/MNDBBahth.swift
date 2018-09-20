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
    var bahthInList : [Int]
    var bahthNatija = [MNBahthNatija]()
    var rdsBahth : MNRecordset?
    
    init(bahthJomla : String , bahthIsm : String = "" , bahthInList : [Int]) {
        bahth = MNBahth(bahth: bahthJomla, bahthIsm: bahthIsm)
        self.bahthInList = bahthInList
    }
    
}
