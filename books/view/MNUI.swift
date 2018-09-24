//
//  MNUI.swift
//  books
//
//  Created by merhab on 24‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import UIKit

class MNUI: NSObject {
    var viewController : UIViewController
    
     init(viewController : UIViewController) {
        self.viewController = viewController
    }
    
     func messageDlg(title : String , message : String ){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
}
