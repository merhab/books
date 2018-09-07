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
        func moveFiles(file :String) {
            let bookInfo = BookInfo ()
            let book  = Book()
            
            if   MNFile.moveFileToBookFolder(file: file) {
                //
            }
        }
        super.viewDidLoad()
        
        // will move all books files from resource to the book directory in doc
        //todo: update the bookslist database
        if MNFile.createFolderInDocuments(folder: MNFile.booksFolderName) {
          let any =  MNFile.searchDbFilesInRes(myFunc: MNFile.moveFileToBookFolder)
            print(any)
        }
        
        var db : MNDatabase
        db = MNDatabase(path: MNFile.getDataBasePath(book: "booksList.kitab"))
        
        
        let myBooks = BooksList()
        rdsBooksList = MNRecordset(database: db, record: myBooks)
        

        
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
