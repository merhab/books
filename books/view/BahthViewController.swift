//
//  BahthViewController.swift
//  books
//
//  Created by merhab on 24‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import UIKit

class natijaCell : UITableViewCell{
    var natija : MNNatija?
}

class BahthViewController: UIViewController {
    
    let khataKaimaFariga3onwan = "لم تختر مجال البحث🚨 "
    let khataKaimaFarigaNass = "رجاء قم باختيار مجال البحث أولا"
    let dbSelectedBooksList = DBBooksList()
        /*MNRecordset(
        database: MNDatabase(path: MNFile.getBooksListPath()),
        tableName: BooksList().getTableName(),
        whereSql: " selected = 1 ",
        orderBy: "")*/
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dbSelectedBooksList.filtered = false
        dbSelectedBooksList.filter = " selected = 1 "
        dbSelectedBooksList.filtered = true
    }

}
extension BahthViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "natija", for: indexPath) as! natijaCell
        
        
        return cell
        
    }
    
    
}
extension BahthViewController:UITableViewDelegate{
    
}
extension BahthViewController:UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let bahthNass = searchBar.text{
            let dbBahth = MNDBBAhth(bahthJomla: bahthNass, bahthIsm: "بحث : \(MNDate.getTimeStamp())")
            dbBahth.ibhathFiKotob(completion: {_ in return})
            }
        }
    }

