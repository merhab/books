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
    static let dbSuffix = ".kitab"
    static let fihresSuffix = ".fihras"
    static let fihrasFolderName = "FAHARIS"
    static let sinfSuffix = ".sinf"
    /**
     get the working dir work for IOS and MACOS
        - Return Strtring contain the working directory path
     */
    static func getDocFolder()->String{
        #if os(iOS) || os(watchOS) || os(tvOS)
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        #elseif os(OSX)
        let documentsDirectory = Bundle.main.bundleURL.deletingLastPathComponent().path
        #else
        documentsDirectory = ""
        println("OMG, it's that mythical new Apple product!!!")
        #endif
        
        return documentsDirectory
    }
    /**
     get the Fihras dir works for IOS and MACOS
     - Return Strtring contain the working directory path
     */
    
    static func getFahressFolder()->String{
        var path = getDocFolder()
        path = path + "/\(booksFolderName)/\(fihrasFolderName)"
        return path
    }
    
    /**
    create the databases folder works for IOS and MACOS
     - Parameters:
        - name: is string with the databases folder name
     - Return: true is success false else
     */
    static func createDbFolder(folder name:String)->Bool{
        // Create a FileManager instance

        let documentsDirectory = MNFile.getDocFolder()

        let dataPath = documentsDirectory + "/\(name)/"
        return createFolder(path:dataPath)
    }

//***************************
    
    /**
     create a folder folder with the given path
     - Parameters:
     - path: is string with  folder path
     - Return: true is success false else
     */
    static func createFolder(path :String)->Bool{
        let dataPath = path
        let fileManager = FileManager.default
        
        if  !fileManager.fileExists(atPath: dataPath){
            do {  try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch let error as NSError {
                print(error.localizedDescription);
                return false
            }
        } else {return true}
    }
    
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
        let documentsDirectory = MNFile.getDocFolder()
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
    
    /**
    get the path of a book in docs/kotob  works for IOS/MACOS
     - Parameters:
        - name is string contain the kitab id and .kitab extenssion
     */
    
    static func getDataBasePath(book name:String)->String{  // just give the name of database ex:1.kitab
        let documentsDirectory = MNFile.getDocFolder()
        
        let dataPath = "\(documentsDirectory)/\(booksFolderName)/\(name)"
        
        //print (dataPath)


            
            return dataPath

    }
    /**
    get the path of a book in docs/kotob works for IOS/MACOS
     - Parameters:
        - id: integer the Kitab id
     
     */
    static func getDataBasePath(kitabId id:Int)->String{
        let str = "\(id).kitab"
        return getDataBasePath(book: str)
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
    /**
     find all files with .kitab extension in an URL
     - Parameters:
     - pathURL: The Url where we search , files type is .kitab
     */
   static func searchDb(pathURL: URL) -> [String] {
        return searchDb(pathURL: pathURL, suffix: dbSuffix)
    }
    /**
     find all files with given extension in an URL
     - Parameters:
        - pathURL: The Url where we search
        - suffix: the files suffix
     */
    static func searchDb(pathURL: URL,suffix : String) -> [String] {
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
                if path.hasSuffix(suffix){
                    files.append(path)
                }
            }
        }
        
        return files
    }
   /**
     Search all database files in ios its search in doc folder , in macos its search in app folder
     */
   static func searchDbFilesInDoc()->[String]{// use this myFumc to move files

    let documentsPath = MNFile.getDocFolder()
    return searchDb(pathURL: URL(fileURLWithPath: documentsPath))
    }
//    #if os(iOS) || os(watchOS) || os(tvOS)
//    #elseif os(OSX)
//    #else
//    #endif
    #if os(iOS) || os(watchOS) || os(tvOS)
    static func searchDbFilesInRes()->[String]{// use this myFumc to move files
        
        let documentsPath = Bundle.main.resourcePath! //+ "/Resources"
        return searchDb(pathURL: URL(fileURLWithPath: documentsPath))
    }
    static func searchDbFilesInInbox()->[String]{
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]+"/Inbox"
        return searchDb(pathURL: URL(fileURLWithPath: documentsPath))
        
    }
    #else
    static func searchDbFilesInRes()->[String]{// use this
        return [String]()
    }
    static func searchDbFilesInInbox()->[String]{
        return [String]()
        
    }

    #endif
    /**
     Search all fihres files in ios its search in doc folder , in macos its search in app folder
     */
    static func searchINDFilesInDoc()->[String]{// use this myFumc to move files
        
        let documentsPath = MNFile.getDocFolder()
        return searchDb(pathURL: URL(fileURLWithPath: documentsPath),suffix: fihresSuffix)
    }
    #if os(iOS) || os(watchOS) || os(tvOS)
    static func searchIndFilesInRes()->[String]{// use this myFumc to move files
        
        let documentsPath = Bundle.main.resourcePath! //+ "/Resources"
        return searchDb(pathURL: URL(fileURLWithPath: documentsPath),suffix: ".fihras")
    }
    static func searchIndFilesInInbox()->[String]{
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]+"/Inbox"
        return searchDb(pathURL: URL(fileURLWithPath: documentsPath),suffix: ".fihras")
        
    }
     #else
    static func searchIndFilesInRes()->[String]{// use this
        return [String]()
    }
    static func searchIndFilesInInbox()->[String]{
        return [String]()
        
    }
    #endif
    
    
    
    static func getAppPath()->String{
        return  Bundle.main.bundleURL.deletingLastPathComponent().path
        
    }
    
    static func getIdFromPath(path : String) -> Int {
        let str = URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
        if let int = Int(str){
         return int
        } else {return -1}
    }
    
    static func getFihrasPathFromKitabId(kitabId:Int)->String{
        var str = getDocFolder()
        str = str + "/\(booksFolderName)/\(fihrasFolderName)/\(kitabId)\(fihresSuffix)"
        return str
    }
    
    static func getSinfPathFromKitabId (idKitab : Int)->String{
        var str =  getDocFolder()
        str = str + "/\(booksFolderName)/\(fihrasFolderName)/\(idKitab)\(sinfSuffix)"
        return str
        
    }

    
    
}

