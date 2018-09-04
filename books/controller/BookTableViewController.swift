//
//  ViewController.swift
//  books
//
//  Created by merhab on 28‏/8‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import UIKit

class Mycell: UITableViewCell {
    

    
    @IBOutlet weak var aLabel: UILabel!
    
}

class BookTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var db : MNDatabase
    db = MNDatabase(path: "/Users/merhab/Documents/KOTOB/booksList.kitab")
    
    let rds : MNRecordset
    let myBook = BooksList()
    rds = MNRecordset(database: db, record: myBook)
    return rds.recordCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! Mycell
        
       var db : MNDatabase
       db = MNDatabase(path: "/Users/merhab/Documents/KOTOB/booksList.kitab")

       let rds : MNRecordset
        var myBook = BooksList()
      rds = MNRecordset(database: db, record: myBook)
        rds.move(to :indexPath.row)
       myBook = rds.getObject(myRd: myBook) as! BooksList
        cell.aLabel.text=myBook.bkTitle
        return cell
        
        
    }

}
