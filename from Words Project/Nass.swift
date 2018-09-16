//
//  Text.swift
//  words
//
//  Created by merhab on 15‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class Nass {
    var nassIdentificator : NassIdentificator
    static let unknownNassIdentificator = NassIdentificator(ID: -1, kitabID: -1, kalimaBidaya:Kalima(kalima:"", kalimaId: Kalima.unknownKalimaIdentificator), kalimaNihaya: Kalima(kalima:"", kalimaId: Kalima.unknownKalimaIdentificator))
    var nass :String
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

    static let horof = "اأإآءؤئبتثجحخدذرزسشضصطظعغفقكلمنهويىة "
    + "1234567890١٢٣٤٥٦٧٨٩٠"
    static let alif = "اأإآؤئ"
    var kalim = [String]()
    
    init(nass : String , nassIdentificator : NassIdentificator) {
        self.nass = nass
        self.nassIdentificator = nassIdentificator
    }
    
    static func removeTashkil(text : String) -> String {

        let mutableString = NSMutableString(string: text) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, Bool(truncating: 0))
        let normalized = (mutableString as NSMutableString).copy() as! NSString
        

        return String(normalized)
    }
    static func getWords(text : String){
      
        let str = Nass.normalize(text: text)
        let components = str.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        
        print(words)
    }
    
    static func normalize(text : String)->String{
        
        let nassArray = Array(Nass.removeTashkil(text: text))
        var NormalizedArray = [Character]()
        for char in nassArray {
            if Nass.horof.contains(char){
                if Nass.alif.contains(char){
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
struct NassIdentificator {
    var ID : Int
    var kitabID : Int
    var kalimaBidaya : Kalima
    var kalimaNihaya : Kalima
}

