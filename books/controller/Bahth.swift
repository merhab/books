//
//  Bahth.swift
//  books
//
//  Created by merhab on 16‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class Bahth: MNrecord {
    static let and = "و"
    static let or = "او"
    var bahth3an = ""
    var kalimat = [[String:String]]()// key is the word the value is the operator
    
    func bla()  {
        let words = Nass.getNormalizedWords(text: bahth3an)
        var str = ""
        for word in words {
           // if word == 
        }
    }
    
}
