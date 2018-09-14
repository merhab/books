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
        let dbMen = DBMNrecord(database: databaseBookList!, record: Men())
        if databaseExists {
            _ = dbBooksList.updateTableStruct()
            _ = dbCat.updateTableStruct()
            _ = dbMen.updateTableStruct()
        }else {
            _ = dbBooksList.createTable()
            _ = dbCat.createTable()
            _ = dbMen.createTable()
            (dbCat.record as! BooksCat).bkCatTitle = "كل الكتب"
            dbCat.record.ID = 1
            (dbCat.record as! BooksCat).bkCatOrder = -1
            _ = dbCat.insert()
        }
    }
    
    func createDatabaseFolder() -> Bool {
        return MNFile.createFolderInDocuments(folder: MNFile.booksFolderName)
    }
    
    func moveFile(files :[String]) {// TODO  move files must makes a log file
        print(files)
        for file in files {
        var databaseBook : MNDatabase
        databaseBook = MNDatabase(path: file)
        let dbBookInfoFromBooksList = DBMNrecord (database: databaseBookList!, record: BooksList())
        let dbBookInfoFromBook = DBMNrecord(database: databaseBook, record: BooksList())
        let dbMenFromBooksList = DBMNrecord (database: databaseBookList!, record: Men())
        let dbMenFromBook = DBMNrecord(database: databaseBook, record: Men())
        let dbCatFromBooksList = DBMNrecord (database: databaseBookList!, record: BooksCat())
        let dbCatFromBook = DBMNrecord(database: databaseBook, record: BooksCat())
        //print( dbBookInfoFromBook.updateTableStruct())
        dbBookInfoFromBook.getRecordWithId(ID: 1)
        if !dbBookInfoFromBook.isNull {
            dbBookInfoFromBooksList.getFirstRecord(filter: " bkId = \((dbBookInfoFromBook.record as! BooksList).bkId)")
            
           _ = dbBookInfoFromBooksList.saveOrUpdate(dbRecord: dbBookInfoFromBook)
            
            dbMenFromBook.getRecordWithId(ID: 1)
            if !dbMenFromBook.isNull {
                dbMenFromBooksList.getFirstRecord(filter: "menId = \((dbMenFromBook.record as! Men).menId)")
                _ = dbMenFromBooksList.saveOrUpdate(dbRecord: dbMenFromBook)
            }
            
            dbCatFromBook.getRecordWithId(ID: 1)
            if !dbCatFromBook.isNull {
                dbCatFromBooksList.getFirstRecord(filter: "bkCatId = \((dbCatFromBook.record as! BooksCat).bkCatId)")
                _ = dbCatFromBooksList.saveOrUpdate(dbRecord: dbCatFromBook)
            }
            
        }else{
            _ = MNFile.deleteFile(path: file)
            print ("error no info found file deleted  : \(file)")
           
        }
        
        if   MNFile.moveFileToBookFolder(file: file) {
            print ("file moved to book folder: \(file)")
           
        }else{
         print ("error cant moved to book folder: \(file)")
        }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catView.layer.shadowOpacity = 5

        if createDatabaseFolder() {
            connectToBooksList()
            

            rdsBooksList = MNRecordset(database: databaseBookList!, table: BooksList().getTableName())
            rdsCat = MNRecordset(database: databaseBookList!, tableName: BooksCat().getTableName(), whereSql: "", orderBy: "bkCatOrder")
        
 
        
        // will move all books files from resource to the book directory in doc

          var files =  MNFile.searchDbFilesInRes()
          files.append(contentsOf: MNFile.searchDbFilesInDoc())
          moveFile(files: files)
            rdsBooksList?.refresh()
            rdsCat?.refresh()

        }
   
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookView : BookViewController = segue.destination as! BookViewController
        let ind = booksListTableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = booksListTableView.cellForRow(at: ind!) as! Mycell

            bookPath = MNFile.getDataBasePath(book: "\(currentCell.bkId).kitab") // will pass this to the book view let it load the book by itSelf


        bookView.bookPath = self.bookPath
        print(bookView.bookPath)
    }


}



extension BooksListTableViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == booksListTableView {
        return rdsBooksList!.recordCount
        }
        if tableView == catTableView {
            return (rdsCat!.recordCount)
        }
        return 0
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == booksListTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: booksListCellId, for: indexPath) as! Mycell
        rdsBooksList?.move(to :indexPath.row)
        var myBook = BooksList()
        myBook =  DBMNrecord(database: (rdsBooksList?.dataBase)!, record: myBook).getObject(fld: (rdsBooksList?.getField())!) as! BooksList
        //myBook = rdsBooksList?.getObject(myRd: myBook) as! BooksList
        cell.booksListLabel.text=myBook.bkTitle
        cell.bkId = myBook.bkId // will use this to load our book in the book view
        return cell
        }
    if tableView == catTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: catCellId, for: indexPath) as! Mycell
            rdsCat?.move(to :indexPath.row)
            var myCat = BooksCat()
            myCat =  DBMNrecord(database: (rdsCat?.dataBase)!, record: myCat).getObject(fld: (rdsCat?.getField())!) as! BooksCat
            cell.booksListLabel.text=myCat.bkCatTitle
            cell.bkId = myCat.bkCatId// will use this to load our book in the book view
            return cell
        }
       
        return Mycell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      if tableView == catTableView {
      let currentCell = catTableView.cellForRow(at: indexPath) as! Mycell
        rdsBooksList?.filtered = false
        if currentCell.bkId == -1 {
          rdsBooksList?.filter = ""
          rdsBooksList?.filtered = false
        }else{
        rdsBooksList?.filter = " bkCatId = \(currentCell.bkId)"
        rdsBooksList?.filtered = true
        }

        booksListTableView.reloadData()
        catMenuButtonAction(UIBarButtonItem())

        }
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
