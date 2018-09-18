//
//  Text.swift
//  words
//
//  Created by merhab on 15‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class Nass : MNrecord{
    var nass :String
    var kalimaBidaya : Kalima
    var kitabId : Int {
        get {
            return kalimaBidaya.mnKitabId
        }
    }
    var nassNormalized : String {
        get{
            return Nass.normalize(text: nass)
        }
           }
    var nassWithoutTachkil : String {
        get {
            return Nass.removeTashkil(text: nass)
        }
    }

    init(nass : String  , kalimaBidaya : Kalima) {
        self.nass = nass
        self.kalimaBidaya = kalimaBidaya

    }
    
    static func removeTashkil(text : String) -> String {

        let mutableString = NSMutableString(string: text) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, Bool(truncating: 0))
        let normalized = (mutableString as NSMutableString).copy() as! NSString
        

        return String(normalized)
    }
    static func getWords(text : String)->[String]{
      
        let str = text
        let components = str.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        
        return words
    }
    
    static func getNormalizedWords(text : String) -> [String] {
        let str = Nass.normalize(text: text)
        return Nass.getWords(text: str)
    }
    
     func getNormalizedWords() -> [String] {
        let str = Nass.normalize(text: nass)
        return Nass.getWords(text: str)
    }
    func getWords() -> [String] {
        return Nass.getWords(text: nass)
    }
    
    static func normalize(text : String)->String{
        
        let nassArray = Array(Nass.removeTashkil(text: text))
        var NormalizedArray = [Character]()
        for char in nassArray {
            if StemConst.horof.contains(char){
                if StemConst.alif.contains(char){
                    NormalizedArray.append("ء")
                    
                }else if char == "ي"
                { NormalizedArray.append("ى")
                }else {
                NormalizedArray.append(char)
                }
            }
        }
        return String(NormalizedArray)
    }
}

extension String {
    var words: [String] {
        var words: [String] = []
        self.enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) { word,_,_,_ in
            guard let word = word else { return }
            words.append(word)
        }
        return words
    }
}


