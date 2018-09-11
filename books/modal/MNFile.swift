//
//  MNFile.swift
//  books
//
//  Created by merhab on 30‏/8‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation

class MNFile  {
    static let booksFolderName = "KOTOB"
    
    static func createFolderInDocuments(folder name:String)->Bool{
        // Create a FileManager instance
        
        let fileManager = FileManager.default
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        let dataPath = documentsDirectory + "/\(name)/"
        
        
        if  !fileManager.fileExists(atPath: dataPath){
            do {  try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch let error as NSError {
                print(error.localizedDescription);
                return false
            }
        } else {return true}
    }

//***************************
    
 static func moveFileFromDocToBookFolder(file name:String)->Bool{ // only file name and extention
    
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let documentsDirectory = paths[0]
    let dataPath = "\(documentsDirectory)/\(name)"
    return  moveFileToBookFolder(file: dataPath)
   
    
}
    
    //**************************
    
    
    static func moveFileToBookFolder(file path:String)->Bool{ // this need full path
        // Create a FileManager instance
        
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        let name = (path as NSString).lastPathComponent
        //let dataPath2 = documentsDirectory.appendingPathComponent(booksFolderName)!.appendingPathComponent(name)
        let dataPath = "\(documentsDirectory)/\(booksFolderName)/\(name)"
        // Move 'hello.swift' to 'subfolder/hello.swift'
        if  !fileManager.fileExists(atPath: dataPath){
            do {
                if fileManager.isDeletableFile(atPath: path){
                  try fileManager.moveItem(atPath: path, toPath: dataPath)
                }else{
                 try fileManager.copyItem(atPath: path, toPath: dataPath)
                }
                return true
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
                return false
            }
        }else{
            print("file \(name) already exists in \(booksFolderName)")
            return false
        }
        
    }
    
    //***********************
    
    static func getDataBasePath(book name:String)->String{  // just give the name of database ex:1.kitab
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let dataPath = "\(documentsDirectory)/\(booksFolderName)/\(name)"
        
        //print (dataPath)


            
            return dataPath

    }
    
    static func fileExists(path : String)->Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path){
            
            return true
        }else{
            return false // no book found in path
        }
    }
    
    static func deleteFile(path : String)-> Bool{
        let fileManager = FileManager.default
        do { try fileManager.removeItem(atPath: path)
            return true
        } catch{ return false
            
        }
    }
   static func searchDb(pathURL: URL) -> [String] {
        var files = [String]()
        let fileManager = FileManager.default
        let keys = [URLResourceKey.isDirectoryKey, URLResourceKey.localizedNameKey]
        let options: FileManager.DirectoryEnumerationOptions = [.skipsPackageDescendants, .skipsSubdirectoryDescendants, .skipsHiddenFiles]
        
        let enumerator = fileManager.enumerator(
            at: pathURL,
            includingPropertiesForKeys: keys,
            options: options,
            errorHandler: {(url, error) -> Bool in
                return true
        })
        
        if enumerator != nil {
            while let file = enumerator!.nextObject() {
                let path =  (file as! URL).path 
                if path.hasSuffix(".kitab"){
                    files.append(path)
                }
            }
        }
        
        return files
    }
   static func searchDbFilesInDoc()->[String]{// use this myFumc to move files

    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    return searchDb(pathURL: URL(fileURLWithPath: documentsPath))
    }
    
    static func searchDbFilesInRes()->[String]{// use this myFumc to move files

        let documentsPath = Bundle.main.resourcePath! //+ "/Resources"
        return searchDb(pathURL: URL(fileURLWithPath: documentsPath))
    }
}

