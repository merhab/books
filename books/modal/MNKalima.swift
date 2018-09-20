//
//  Word.swift
//  words
//
//  Created by merhab on 15‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class MNKalima : MNrecord {
    var mnKitabId = -1
    var mnSafhaId = -1
    var mnTartibInSafha = -1.0
    var kalima : String = ""
    
    init(text : String = "" , kitabId : Int = -1 , safhaId : Int = -1 ,
         tartibInSafha : Double = -1.0 ) {
        self.kalima = text
        self.mnKitabId = kitabId
        self.mnKitabId = kitabId
        self.mnSafhaId = safhaId
        self.mnTartibInSafha = tartibInSafha
    }
    func getPrefix(count : Int) -> String {
        return String(kalima.prefix(count))
    }
    
    func getSuffix(count : Int) -> String {
        return String(kalima.suffix(count))
    }
    static func getJithr(wrd : String) -> String {
     var str = getJithr1(wrd : wrd)
        str = getJithr2(wrd: str)
        str = getJithr3(wrd: str)
        return str
    }
    static private func getJithr1(wrd : String) -> String {

        let word = MNKalima(text: wrd)
        
           // print (word.getPrefix(count: 4))
            
           // print (word.getSuffix(count: 3))
            var success = false
        repeat {
            success = true
            for i in stride(from: ArabiaThawabit.maxSuffix, to: 0, by: -1) {
                let prefix = word.getSuffix(count: i)
                if ArabiaThawabit.suffixList.contains(prefix) {
                    let endIndex = word.kalima.index(word.kalima.endIndex, offsetBy: -i)
                    let truncated = word.kalima.substring(to: endIndex)
                    if truncated.count>2 {
                        word.kalima = truncated
                        success = true
                        break
                    } else {
                        success =  false
                    }

                } else { success = false}
            }
                     } while success
            repeat {
                success = true
                for i in  stride(from: ArabiaThawabit.maxPrefix, to: 0, by: -1)  {
                    let prefix = word.getPrefix(count: i)
                    if ArabiaThawabit.prifixList.contains(prefix) {
                        let t  = String(word.kalima.dropFirst(prefix.count))
                        if t.count>2 {
                            word.kalima = t
                            success = true
                            break
                        }else
                        {
                            success = false
                        }

                    }else {
                        success = false
                    }
                }
            } while success
            
            
            
            
          //  print (word.word)
        return word.kalima
        }
    static private func getJithr2(wrd : String) -> String {

        var array = Array(wrd)
        if wrd.count > 3 {
  
            if ArabiaThawabit.ajwafLetters.contains(array[1]) {
              array.remove(at: 1)
                return(String(array))
            }
            if ArabiaThawabit.ajwafLetters.contains(array[array.count-2]){
                array.remove(at: array.count-2)
                return String(array)
            }
        }
        return String(array)
    }
    
    static private func getJithr3(wrd : String) -> String {

        var array = Array(wrd)
        if wrd.count > 3 {
            
            if ArabiaThawabit.infixLetters.contains(array[1]) {
                array.remove(at: 1)
                return(String(array))
            }
            if ArabiaThawabit.infixLetters.contains(array[array.count-2]){
                array.remove(at: array.count-2)
                return String(array)
            }
        }
        return String(array)
    }
    
  
    
}

class MNKalimaDescription : MNrecord {

    var kalimaId = -1
    var kalimaType = ""
    var kalimaDhamir = ""
    var kalimaZamen = ""
    var kalimaJithr = ""
}
class MNKalimaTartib: MNrecord {
   var idKalima = -1
   var tartib = -1.0
    var idKitab = -1
    var idSafha = -1
     init(kalima : MNKalima) {

        self.idKalima = kalima.ID
        self.idKitab = kalima.mnKitabId
        self.idSafha = kalima.mnSafhaId
        self.tartib = kalima.mnTartibInSafha
        
        
        
    }
    
    
}
