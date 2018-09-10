//
//  ViewController.swift
//  books
//
//  Created by merhab on 28‏/8‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import UIKit

class Mycell: UITableViewCell  {
    

    var bkId = -1
    @IBOutlet weak var booksListLabel: UILabel!
    
    @IBOutlet weak var catLabel: UILabel!
}

class BooksListTableViewController: UIViewController  {
  
    
    // Vars
    
    @IBOutlet weak var catSearchBar: UISearchBar!
    @IBOutlet weak var booksListSearchBar: UISearchBar!
    @IBOutlet weak var catTableView: UITableView!
    @IBOutlet var booksListTableView: UITableView!
    @IBOutlet weak var catViewRightMargin: NSLayoutConstraint!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var catViewTrailling: NSLayoutConstraint!
    
    var databaseBookList : MNDatabase?
    var rdsBooksList : MNRecordset?
    var rdsCat : MNRecordset?
    var bookPath = ""
    let booksListCellId = "booksListCell"
    let catCellId = "catCell"
    
    @IBAction func catMenuButtonAction(_ sender: UIBarButtonItem) {
        if catViewTrailling.constant == 0  {
           catViewTrailling.constant = 311
        }else {
         catViewTrailling.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
       
    }
    func connectToBooksList(){
        var databaseExists = false
        if MNFile.fileExists(path: MNFile.getDataBasePath(book: "booksList.kitab")) {
            databaseExists = true
        } else {
            databaseExists = false
        }
        databaseBookList = MNDatabase(path: MNFile.getDataBasePath(book: "booksList.kitab"))
        let dbBooksList = DBMNrecord(database: databaseBookList!, record: BooksList())
        let dbCat = DBMNrecord(database: databaseBookList!, record: BooksCat())
        if databaseExists {
            _ = dbBooksList.updateTableStruct()
            _ = dbCat.updateTableStruct()
        }else {
            _ = dbBooksList.createTable()
            _ = dbCat.createTable()
            (dbCat.record as! BooksCat).bkCatTitle = "عقيدة"
            _ = dbCat.insert()
        }
    }
    
    func createDatabaseFolder() -> Bool {
        return MNFile.createFolderInDocuments(folder: MNFile.booksFolderName)
    }
    
    func moveFile(file :String)-> Bool {// TODO  move files must makes a log file
        
        var databaseBook : MNDatabase
        databaseBook = MNDatabase(path: file)
        let dbBookInfoFromBooksList = DBMNrecord (database: databaseBookList!, record: BooksList())
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catView.layer.shadowOpacity = 5

        if createDatabaseFolder() {
            connectToBooksList()
            

            rdsBooksList = MNRecordset(database: databaseBookList!, table: BooksList().getTableName())
            rdsCat = MNRecordset(database: databaseBookList!, table: BooksCat().getTableName())
        
 
        
        // will move all books files from resource to the book directory in doc

          var any =  MNFile.searchDbFilesInRes(myFunc: moveFile)
          any.append(contentsOf: MNFile.searchDbFilesInDoc(myFunc: moveFile))

        }
   
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookView : BookViewController = segue.destination as! BookViewController
        let ind = booksListTableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = booksListTableView.cellForRow(at: ind!) as! Mycell
        if currentCell.bkId == 1 { // just for testing
            bookPath = MNFile.getDataBasePath(book: "\(currentCell.bkId).kitab") // will pass this to the book view let it load the book by itSelf
            
        }

        bookView.bookPath = self.bookPath
        print(bookView.bookPath)
    }


}



extension BooksListTableViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == booksListTableView {
        return rdsBooksList!.range.recordCount
        }
        if tableView == catTableView {
            return (rdsCat!.range.recordCount)
        }
        return 0
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == booksListTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: booksListCellId, for: indexPath) as! Mycell
        rdsBooksList?.move(to :indexPath.row)
        var myBook = BooksList()
        myBook =  DBMNrecord(database: (rdsBooksList?.database)!, record: myBook).getObject(fld: (rdsBooksList?.getField())!) as! BooksList
        //myBook = rdsBooksList?.getObject(myRd: myBook) as! BooksList
        cell.booksListLabel.text=myBook.bkTitle
        cell.bkId = myBook.bkId // will use this to load our book in the book view
        return cell
        }
    if tableView == catTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: catCellId, for: indexPath) as! Mycell
            rdsCat?.move(to :indexPath.row)
            var myCat = BooksCat()
            myCat =  DBMNrecord(database: (rdsCat?.database)!, record: myCat).getObject(fld: (rdsCat?.getField())!) as! BooksCat
            cell.booksListLabel.text=myCat.bkCatTitle
            cell.bkId = myCat.bkCatId// will use this to load our book in the book view
            return cell
        }
       
        return Mycell()
    }
}



extension BooksListTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar == booksListSearchBar {
        if searchText == "" { rdsBooksList?.filtered = false}  else {
            rdsBooksList?.filter = " bkTitle like '%\(searchText)%'"
            rdsBooksList?.filtered = true}
        booksListTableView.reloadData()
    }
        if searchBar == catSearchBar {
            if searchText == "" { rdsCat?.filtered = false}  else {
                rdsCat?.filter = " bkCatTitle like '%\(searchText)%'"
                rdsCat?.filtered = true}
            catTableView.reloadData()
        }
    }
    
    
}
