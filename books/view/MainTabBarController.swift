//
//  MainTabBarController.swift
//  books
//
//  Created by merhab on 24‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController , UITabBarControllerDelegate {
    let khataKaimaFariga3onwan = "لم تختر مجال البحث🚨 "
    let khataKaimaFarigaNass = "رجاء قم باختيار مجال البحث أولا"

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.restorationIdentifier == "bahth" {
            let path = MNFile.getBooksListPath()
            let rds = MNRecordset(database: MNDatabase(path: path), table: BooksList().getTableName())
            rds.filter = " selected = 1 "
            rds.filtered = true
            if rds.isEmpty {
                //TODO" change the tilte of messageBox
                MNUI(viewController: self).messageDlg(title: khataKaimaFariga3onwan, message: khataKaimaFarigaNass)
                return false
                
            }
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
