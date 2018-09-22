//
//  MNKitabSinf.swift
//  kotobi
//
//  Created by merhab on 22‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//


/**
 this class to make an table link cat to books list , so we can have same book in diffirent cat
 */
import Foundation
class MNKitabSinf : MNrecord{
    var idKitab = -1
    var idCat = -1
    var sqlGetEqualRecordFromDatabase : String {
    get { return " select ID from MNkitabSinf where idKitab = \(idKitab) and idCat = \(idCat)"}}
}
