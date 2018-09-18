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
        if !(dbKitab?.akhirKitab)!{
        dbKitab!.lahik()

        self.page.text = dbKitab!.getCurrentSafha().nass
        page.rightToLeftAnimation()
        }
    }

    @IBAction func swipRight(_ sender: UISwipeGestureRecognizer) {
        if !(dbKitab?.awalKitab)! {
        dbKitab!.sabik()

    //    UIView.transition(with: self.page, duration: 0.6, options: [.curveEaseInOut,.transitionCurlUp], animations: {self.page.text = self.book.pgText})
        self.page.text = dbKitab!.getCurrentSafha().nass
        page.leftToRightAnimation()
        }
    }
    
    @IBOutlet weak var page: UITextView!

        var dbKitab  : DbKitab?
        var kitabId = -1
      
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.viewSwipped(_:)))
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
//        page.addGestureRecognizer(swipeLeft)
        dbKitab = DbKitab(kitabId: kitabId)
        page.text = dbKitab!.getCurrentSafha().nass
        
    }
    
    
   @objc func viewSwipped(gesture: UIGestureRecognizer) {
      //  self.chooseAQuote()
        
        if let swippedView = gesture.view {
            //swippedView.slideInFromRight()
            if swippedView.tag == 1 {
                page.leftToRightAnimation()
                self.page.text = dbKitab!.getCurrentSafha().nass
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
