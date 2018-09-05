//
//  BookViewController.swift
//  books
//
//  Created by merhab on 5‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
import UIKit
class BookViewController: UIViewController {
    @IBAction func swipLeft(_ sender: UISwipeGestureRecognizer) {
        rdsBook?.moveNext()
        book = rdsBook?.getObject(myRd: book) as! Book
        page.text = book.pgText
        
    }

    @IBAction func swipRight(_ sender: UISwipeGestureRecognizer) {
        rdsBook?.movePreior()
        book = rdsBook?.getObject(myRd: book) as! Book
        page.text = book.pgText
    }
    
    @IBOutlet weak var page: UITextView!
        var rdsBook : MNRecordset?
        var database : MNDatabase?
        var book = Book()
        var bookPath = ""
      
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = MNDatabase(path: bookPath)
        
        
        rdsBook = MNRecordset(database: database!, record: book)
        book = rdsBook?.getObject(myRd: book) as! Book

        page.text = book.pgText
    }
}
