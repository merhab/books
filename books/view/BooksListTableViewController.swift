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
    var kitabInfoFromBooksList : BooksList?
    var sinf : BooksCat?

    @IBOutlet weak var booksListLabel: UILabel!
    
    @IBOutlet weak var catLabel: UILabel!
}

class BooksListTableViewController: UIViewController  {
  
    
    // Vars
    var isSelectingBooks = false
    var selectedBooks = [Int]()
    let finishSelectionCaption = "تم"
    let startSelectionCaption = "تحديد"
    @IBOutlet weak var catSearchBar: UISearchBar!
    @IBOutlet weak var booksListSearchBar: UISearchBar!
    @IBOutlet weak var catTableView: UITableView!
    @IBOutlet var booksListTableView: UITableView!
    @IBOutlet weak var catViewRightMargin: NSLayoutConstraint!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var catViewTrailling: NSLayoutConstraint!
    @IBOutlet weak var saveSelectionButton: UIButton!
    
    var dbBooksList : DBBooksList?
    var dbBookListProtocol : DbBookListProtocol?
    var bookPath = ""
    let booksListCellId = "booksListCell"
    let catCellId = "catCell"
    
    @IBAction func saveSelecion(_ sender: UIButton) {
        dbBooksList?.saveSelected()
    }
    @IBAction func catMenuButtonAction(_ sender: UIBarButtonItem) {
        if catViewTrailling.constant == 0  {
           catViewTrailling.constant = 311
        }else {
         catViewTrailling.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})

        }
       
    @IBAction func selectAction(_ sender: UIButton) {
        isSelectingBooks = !isSelectingBooks
        if isSelectingBooks{
          sender.setTitle(finishSelectionCaption, for: .normal)
          saveSelectionButton.isEnabled = true
        } else {
          sender.setTitle(startSelectionCaption, for: .normal)
          saveSelectionButton.isEnabled = false
        }
        

    }
    
    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        catView.layer.shadowOpacity = 5
        dbBooksList = DBBooksList()
        dbBooksList?.getDataBases()
        if let dbProtocol = dbBookListProtocol {
            dbProtocol.getDbBookList(dbBookList: dbBooksList!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !isSelectingBooks {
        let bookView : BookViewController = segue.destination as! BookViewController
        let ind = booksListTableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = booksListTableView.cellForRow(at: ind!) as! Mycell

            bookPath = MNFile.getDataBasePath(book: "\(currentCell.bkId).kitab") // will pass this to the book view let it load the book by itSelf


        bookView.kitabId = currentCell.bkId
        
    }
    }
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if !isSelectingBooks {return true} else {return false}
    }


}



extension BooksListTableViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == booksListTableView {
        return dbBooksList!.recordCount
        }
        if tableView == catTableView {
            return (dbBooksList!.rdsCat.recordCount)
        }
        return 0
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == booksListTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: booksListCellId, for: indexPath) as! Mycell
        dbBooksList!.taharakIla(mawki3 :indexPath.row)
        var myBook = BooksList()
        myBook =  DBMNrecord(database: (dbBooksList!.dataBase), record: myBook).getObject(fld: (dbBooksList!.getFields())) as! BooksList
        //myBook = rdsBooksList?.getObject(myRd: myBook) as! BooksList
        cell.booksListLabel.text=myBook.bkTitle
        cell.bkId = myBook.bkId // will use this to load our book in the book view
        cell.kitabInfoFromBooksList = myBook
        // make the checkbox appear or disappear
        if myBook.selected {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
        }
    if tableView == catTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: catCellId, for: indexPath) as! Mycell
            dbBooksList!.rdsCat.move(to :indexPath.row)
            var myCat = BooksCat()
            myCat =  DBMNrecord(database: (dbBooksList!.rdsCat.dataBase), record: myCat).getObject(fld: (dbBooksList!.rdsCat.getCurrentRecordAsDictionary())) as! BooksCat
            cell.booksListLabel.text=myCat.bkCatTitle
            cell.bkId = myCat.ID// will use this to load our books in the book view
            cell.sinf = myCat
                // make the checkbox appear or disappear
        if myCat.selected {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
            return cell
        }
       
        return Mycell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

      if tableView == catTableView {
      let currentCell = catTableView.cellForRow(at: indexPath) as! Mycell
        dbBooksList!.filtered = false
        // the case of all books is when cat ID = 1
        if currentCell.bkId == 1 {
          dbBooksList!.filter = ""
          dbBooksList!.filtered = false
        }else{
            // we start the cat by the record 1: all books
            // witch is not from the database
            // so we need to reduce it
            dbBooksList?.setFilterByAsnaf(ID: currentCell.bkId)
            dbBooksList!.filtered = true

        }
        booksListTableView.reloadData()
        
       // catMenuButtonAction(UIBarButtonItem())
        }
        // handle the selection checkbox
        if isSelectingBooks {
        let cell = tableView.cellForRow(at: indexPath) as! Mycell
        if tableView == catTableView {

         //update the checkbox of cat list
        if cell.accessoryType == UITableViewCellAccessoryType.checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.sinf?.selected = false
            _ = DBMNrecord(database: dbBooksList!.dataBase, record: cell.sinf!).update()
            dbBooksList?.saveSelectedFilteredBooks(idCat: cell.sinf!.ID, selected: false)
            }else{
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            cell.sinf?.selected = true
            _ = DBMNrecord(database: dbBooksList!.dataBase, record: cell.sinf!).update()
            dbBooksList?.saveSelectedFilteredBooks(idCat: cell.sinf!.ID, selected: true)
            }
                    booksListTableView.reloadData()
      } else {
            // update the checkbox of books list
            if cell.accessoryType == UITableViewCellAccessoryType.checkmark {
                cell.accessoryType = UITableViewCellAccessoryType.none
                cell.kitabInfoFromBooksList?.selected = false
                _ = DBMNrecord(database: dbBooksList!.dataBase, record: cell.kitabInfoFromBooksList!).update()
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                cell.kitabInfoFromBooksList?.selected = true
                _ = DBMNrecord(database: dbBooksList!.dataBase, record: cell.kitabInfoFromBooksList!).update()
            }
            }
        
    }
   
    }

}



extension BooksListTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar == booksListSearchBar {
        if searchText == "" { dbBooksList!.filtered = false}  else {
            dbBooksList!.filter = " bkTitle like '%\(searchText)%'"
            dbBooksList!.filtered = true}
        booksListTableView.reloadData()
    }
        if searchBar == catSearchBar {
            if searchText == "" { dbBooksList!.rdsCat.filtered = false}  else {
                dbBooksList!.rdsCat.filter = " bkCatTitle like '%\(searchText)%'"
                dbBooksList!.rdsCat.filtered = true}
            catTableView.reloadData()
        }
    }
    
    
}

protocol DbBookListProtocol {
    func getDbBookList(dbBookList : DBBooksList)
}
