//
//  Word.swift
//  words
//
//  Created by merhab on 15‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class Kalima {
    static let unknownKalimaIdentificator = KalimaIdentificator(ID: -1, kitabId: -1, safhaId: -1, tartibInSafha: -1)
    var kalimaId : KalimaIdentificator
    var kalimaDiscription : KalimaDescription?
    var kalima : String
    
    init(kalima : String ,kalimaId : KalimaIdentificator ) {
        self.kalima = kalima
        self.kalimaId = kalimaId
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

        let word = Kalima(kalima: wrd , kalimaId: unknownKalimaIdentificator)
           // print (word.getPrefix(count: 4))
            
           // print (word.getSuffix(count: 3))
            var success = false
        repeat {
            success = true
            for i in stride(from: StemConst.maxSuffix, to: 0, by: -1) {
                let prefix = word.getSuffix(count: i)
                if StemConst.suffixList.contains(prefix) {
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
                for i in  stride(from: StemConst.maxPrefix, to: 0, by: -1)  {
                    let prefix = word.getPrefix(count: i)
                    if StemConst.prifixList.contains(prefix) {
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
  
            if StemConst.ajwafLetters.contains(array[1]) {
              array.remove(at: 1)
                return(String(array))
            }
            if StemConst.ajwafLetters.contains(array[array.count-2]){
                array.remove(at: array.count-2)
                return String(array)
            }
        }
        return String(array)
    }
    
    static private func getJithr3(wrd : String) -> String {

        var array = Array(wrd)
        if wrd.count > 3 {
            
            if StemConst.infixLetters.contains(array[1]) {
                array.remove(at: 1)
                return(String(array))
            }
            if StemConst.infixLetters.contains(array[array.count-2]){
                array.remove(at: array.count-2)
                return String(array)
            }
        }
        return String(array)
    }
    
 
    
}
struct KalimaIdentificator {
    var ID : Int
    var kitabId : Int
    var safhaId : Int
    var tartibInSafha : Double
}
struct KalimaDescription {
    var ID : Int
    var kalimaId : KalimaIdentificator
    var kalimaType : String
    var kalimaDhamir : String?
    var kalimaTime : String?
    var kalimaJithr : KalimaIdentificator
}
