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
        book =  DBMNrecord(database: database!, record: book).getObject(fld: (rdsBook?.getField())!) as! Book
   //     UIView.transition(with: self.page, duration: 0.6, options: [.curveEaseInOut,.transitionCurlDown], animations: {self.page.text = self.book.pgText})
        self.page.text = self.book.pgText
        page.rightToLeftAnimation()
    }

    @IBAction func swipRight(_ sender: UISwipeGestureRecognizer) {
        rdsBook?.movePreior()
        book =  DBMNrecord(database: database!, record: book).getObject(fld: (rdsBook?.getField())!) as! Book
    //    UIView.transition(with: self.page, duration: 0.6, options: [.curveEaseInOut,.transitionCurlUp], animations: {self.page.text = self.book.pgText})
        self.page.text = self.book.pgText
        page.leftToRightAnimation()
    }
    
    @IBOutlet weak var page: UITextView!
        var rdsBook : MNRecordset?
        var database : MNDatabase?
        var book = Book()
        var bookPath = ""
      
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.viewSwipped(_:)))
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
//        page.addGestureRecognizer(swipeLeft)
        

        database = MNDatabase(path: bookPath)
        let dbRecord = DBMNrecord(database: database!, record: book)
        _ = dbRecord.updateTableStruct()
        
        rdsBook = MNRecordset(database: database!, table: book.getTableName())
        book =  dbRecord.getObject(fld: (rdsBook?.getField())!) as! Book
        //book = rdsBook?.getObject(myRd: book) as! Book

        page.text = book.pgText
        
    }
    
    
   @objc func viewSwipped(gesture: UIGestureRecognizer) {
      //  self.chooseAQuote()
        
        if let swippedView = gesture.view {
            //swippedView.slideInFromRight()
            if swippedView.tag == 1 {
                page.leftToRightAnimation()
                self.page.text = self.book.pgText
            } else {
              //  page.leftToRightAnimation()
                //label2.text = displayString
            }
        }
    }
}

extension UIView {
    func leftToRightAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            leftToRightTransition.delegate = (delegate as! CAAnimationDelegate)
        }
        
        leftToRightTransition.type = kCATransitionPush
        leftToRightTransition.subtype = kCATransitionFromRight
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        leftToRightTransition.fillMode = kCAFillModeRemoved
        
        
        // Add the animation to the View's layer
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
    }
    func rightToLeftAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition object
        let rightToLeftAnimation = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            rightToLeftAnimation.delegate = (delegate as! CAAnimationDelegate)
        }
        
        rightToLeftAnimation.type = kCATransitionPush
        rightToLeftAnimation.subtype = kCATransitionFromLeft
        rightToLeftAnimation.duration = duration
        rightToLeftAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rightToLeftAnimation.fillMode = kCAFillModeRemoved
        
        
        // Add the animation to the View's layer
        self.layer.add(rightToLeftAnimation, forKey: "rightToLeftAnimation")
    }
}
