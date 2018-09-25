//
//  Book.swift
//  books
//
//  Created by merhab on 28‏/8‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation

class MNrecordParams: MNrecord {
    var currentPosition = -1
}

class BooksList: MNrecord {
    var bkAuthor  = -1
    var bkAuthorInfo  = ""
    var bkCatId  = -1
    var bkId  = -1
    var bkMohakik  = -1
    var bkPublisher  = ""
    var bkTitle  = ""
    var bkVersion  = -1
    var bkYearPublication  = -1

    
}




//***********************

class Men : MNrecord {
    var menbirthYear  = -1
    var menDieYear  = -1
    var menFullName  = ""
    var menId  = -1
    var menInfo  = ""
    var menName  = ""
    var menSurName  = ""
    var menTown  = ""
}




class Book : MNrecord {
    var pgFormattedText  = ""
    var pgIndexedText  = ""
    var pgOrder  = -1.0
    var pgText  = ""
    var pgVersion  = -1
    var volume  = -1
    var pgId = -1
}

class BookIndex : MNrecord {
    
    var indDeep  = -1
    var indFormattedText  = ""
    var indId  = -1
    var IndParent  = -1
    var indText  = ""
    var indIndexedText  = ""
    var indOrder  = -1.0
}



class BooksCat : MNrecord {
    var bkCatDeep  = -1
    var bkCatId  = -1
    var bkCatOrder  = -1.0
    var bkCatParentId  = -1
    var bkCatTitle  = ""
    var bkCatTitleFormatted  = ""
    var bkCatTitleIndexed  = ""
}
// to get bahth nataij
class KitabFahras: MNrecord {
    static let kitabFahrasTableName = "kitabFahras"
    static let bahthCols = "rowId as ID , rank"
    var rank = -1.0
}




