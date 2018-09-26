//
//  BahthViewController.swift
//  books
//
//  Created by merhab on 24‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import UIKit

class natijaCell : UITableViewCell{
    var natija = MNNatija(){
        didSet{
            kitab3onwanLabel.text = natija.kitab3onwan
            safhaLabel.text = natija.safha
        }
    }
    @IBOutlet weak var kitab3onwanLabel: UILabel!
    @IBOutlet weak var safhaLabel: UILabel!
}

class BahthViewController: UIViewController {
    var rdsNatija : MNRecordset?
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
        if let rds = rdsNatija{
        return rds.recordCount
        }else {return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "natija", for: indexPath) as! natijaCell
        if let rds = rdsNatija {

            let dbNatija = DBMNrecord(database: rds.dataBase, record: MNNatija())
            cell.natija = dbNatija.getObject(fld: rds.getCurrentRecordAsDictionary()) as! MNNatija
        }
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
            rdsNatija = MNRecordset(database: MNDatabase(path: MNFile.getBahthDatabasePath()),
                                  tableName: MNNatija().getTableName(),
                                  whereSql: "bahthId = \(dbBahth.bahthId)",
                                  orderBy: "rank")
            }
        }
    }

