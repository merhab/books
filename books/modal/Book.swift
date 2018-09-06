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
extension BooksList : Comparable {
    static func < (lhs: BooksList, rhs: BooksList) -> Bool {
      return  (lhs.bkVersion > rhs.bkVersion)
    }
    
    static func == (lhs: BooksList, rhs: BooksList) -> Bool {
       return (lhs.bkId == rhs.bkId)
    }
    
    static let mnSqlCreate = """
    CREATE TABLE IF NOT EXISTS "booksList" (
    "bkId" INTEGER DEFAULT -1,
    "bkTitle" TEXT DEFAULT "",
    "bkAuthor" INTEGER DEFAULT -1,
    "bkVersion" INTEGER DEFAULT -1,
    "bkPublisher" TEXT DEFAULT "",
    "bkYearPublication" INTEGER DEFAULT -1,
    "bkAuthorInfo" TEXT DEFAULT "",
    "bkCatId" INTEGER DEFAULT -1,
    "bkMohakik" INTEGER DEFAULT -1,
    "selected" INTEGER DEFAULT 0,
    "BKinstalled" INTEGER DEFAULT 0,
    "ID" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
    );
"""
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

extension Men : Comparable {
    static func < (lhs: Men, rhs: Men) -> Bool {
     return (lhs.menId == rhs.menId)
    }
    
    static func == (lhs: Men, rhs: Men) -> Bool {
     return lhs.menbirthYear > rhs.menbirthYear
    }
    
    
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




