//
//  Book.swift
//  books
//
//  Created by merhab on 28‏/8‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation

class BooksList: MNrecord {
    var bkAuthor  = -1
    var bkAuthorInfo  = ""
    var bkCatId  = -1
    var bkId  = -1
    var bKinstalled  = -1
    var bkMohakik  = -1
    var bkPublisher  = ""
    var bkTitle  = ""
    var bkVersion  = -1
    var bkYearPublication  = -1
    var selected  = false
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
    var PgFormattedText  = ""
    var PgIndexedText  = ""
    var PgOrder  = -1.0
    var pgText  = ""
    var PgVersion  = -1
    var Volume  = -1
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

class BookInfo : MNrecord {
    
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

class BooksCat : MNrecord {
    var bkCatDeep  = -1
    var bkCatId  = -1
    var bkCatOrder  = -1.0
    var bkCatParentId  = -1
    var bkCatTitle  = ""
    var bkCatTitleFormatted  = ""
    var bkCatTitleIndexed  = ""
}




