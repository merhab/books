//
//  ViewController.swift
//  books
//
//  Created by merhab on 28‏/8‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import UIKit

class Mycell: UITableViewCell {
    

    var bkId = -1
    @IBOutlet weak var aLabel: UILabel!
    
}

class BooksListTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var rdsBooksList : MNRecordset?
    var bookPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var databaseBookList : MNDatabase
        if MNFile.createFolderInDocuments(folder: MNFile.booksFolderName) {
        databaseBookList = MNDatabase(path: MNFile.getDataBasePath(book: "booksList.kitab"))
            
        let dbBooksList = DBMNrecord(database: databaseBookList, record: BooksList())
        _ = dbBooksList.createTable()
        _ = dbBooksList.updateTableStruct()
        rdsBooksList = MNRecordset(database: databaseBookList, record: BooksList())
        
        func moveFile(file :String)-> Bool {// TODO  move files must makes a log file

            var databaseBook : MNDatabase
            databaseBook = MNDatabase(path: file)
            let dbBookInfoFromBooksList = DBMNrecord (database: databaseBookList, record: BooksList())
            let dbBookInfoFromBook = DBMNrecord(database: databaseBook, record: BooksList())
           print( dbBookInfoFromBook.updateTableStruct())
            dbBookInfoFromBook.getRecordWithId(ID: 1)
                if !dbBookInfoFromBook.isNull {
                    dbBookInfoFromBooksList.getFirstRecord(filter: " bkId = \((dbBookInfoFromBook.record as! BooksList).bkId)")
                    if dbBookInfoFromBooksList.isNull {
                        dbBookInfoFromBooksList.record = dbBookInfoFromBook.record
                       _ = dbBookInfoFromBooksList.insert()
                    }else {
                        if dbBookInfoFromBook.record > dbBookInfoFromBooksList.record {
                            dbBookInfoFromBooksList.record = dbBookInfoFromBook.record
                        _ = dbBookInfoFromBooksList.update()
                        } else {
                          _ = MNFile.deleteFile(path: file)
                            return false
                        }
                    }
                }else{
                    _ = MNFile.deleteFile(path: file)
                    return false
                }
                
            if   MNFile.moveFileToBookFolder(file: file) {
                
               return true
            }else{
                return false
            }

            
        }
        
        // will move all books files from resource to the book directory in doc

          var any =  MNFile.searchDbFilesInRes(myFunc: moveFile)
          any.append(contentsOf: MNFile.searchDbFilesInDoc(myFunc: moveFile))
            print(any)
        }

        

        
        

        

        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookView : BookViewController = segue.destination as! BookViewController
        let ind = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: ind!) as! Mycell
        if currentCell.bkId == 1 { // just for testing
            bookPath = MNFile.getDataBasePath(book: "\(currentCell.bkId).kitab") // will pass this to the book view let it load the book by itSelf
            
        }

        bookView.bookPath = self.bookPath
        print(bookView.bookPath)
    }
    
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return rdsBooksList!.recordCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! Mycell



        rdsBooksList?.move(to :indexPath.row)
        var myBook = BooksList()
        myBook = rdsBooksList?.getObject(myRd: myBook) as! BooksList
        cell.aLabel.text=myBook.bkTitle
        cell.bkId = myBook.bkId // will use this to load our book in the book view
        return cell
    //
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        }
  

}
