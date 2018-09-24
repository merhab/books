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
    
    var rdsSelectedBooksList : MNRecordset?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
