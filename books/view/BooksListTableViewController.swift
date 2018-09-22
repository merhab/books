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
    
    var dbBooksList : DBBooksList?
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
       
    
    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        catView.layer.shadowOpacity = 5
        dbBooksList = DBBooksList()
        dbBooksList?.getDataBases()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookView : BookViewController = segue.destination as! BookViewController
        let ind = booksListTableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = booksListTableView.cellForRow(at: ind!) as! Mycell

            bookPath = MNFile.getDataBasePath(book: "\(currentCell.bkId).kitab") // will pass this to the book view let it load the book by itSelf


        bookView.kitabId = currentCell.bkId
        
    }


}



extension BooksListTableViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == booksListTableView {
        return dbBooksList!.rdsBooksList.recordCount
        }
        if tableView == catTableView {
            return (dbBooksList!.rdsCat.recordCount)
        }
        return 0
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == booksListTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: booksListCellId, for: indexPath) as! Mycell
        dbBooksList!.rdsBooksList.move(to :indexPath.row)
        var myBook = BooksList()
        myBook =  DBMNrecord(database: (dbBooksList!.rdsBooksList.dataBase), record: myBook).getObject(fld: (dbBooksList!.rdsBooksList.getField())) as! BooksList
        //myBook = rdsBooksList?.getObject(myRd: myBook) as! BooksList
        cell.booksListLabel.text=myBook.bkTitle
        cell.bkId = myBook.bkId // will use this to load our book in the book view
        return cell
        }
    if tableView == catTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: catCellId, for: indexPath) as! Mycell
            dbBooksList!.rdsCat.move(to :indexPath.row)
            var myCat = BooksCat()
        myCat =  DBMNrecord(database: (dbBooksList!.rdsCat.dataBase), record: myCat).getObject(fld: (dbBooksList!.rdsCat.getField())) as! BooksCat
            cell.booksListLabel.text=myCat.bkCatTitle
            cell.bkId = myCat.ID// will use this to load our books in the book view
            return cell
        }
       
        return Mycell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      if tableView == catTableView {
      let currentCell = catTableView.cellForRow(at: indexPath) as! Mycell
        dbBooksList!.rdsBooksList.filtered = false
        // the case of all books is when cat ID = 1
        if currentCell.bkId == 1 {
          dbBooksList!.rdsBooksList.filter = ""
          dbBooksList!.rdsBooksList.filtered = false
        }else{
            // we start the cat by the record 1: all books
            // witch is not from the database
            // so we need to reduce it
            dbBooksList?.setFilterByAsnaf(catId: currentCell.bkId)
            dbBooksList!.rdsBooksList.filtered = true

        }
        booksListTableView.reloadData()
        
        catMenuButtonAction(UIBarButtonItem())
        }
        }
   


}



extension BooksListTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar == booksListSearchBar {
        if searchText == "" { dbBooksList!.rdsBooksList.filtered = false}  else {
            dbBooksList!.rdsBooksList.filter = " bkTitle like '%\(searchText)%'"
            dbBooksList!.rdsBooksList.filtered = true}
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
