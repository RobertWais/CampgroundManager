//
//  SiteVC.swift
//  independentStudy
//
//  Created by Robert Wais on 2/7/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class SiteVC: UIViewController {

    var wholeSite: Site!
    
    @IBOutlet var siteNumberLbl: UILabel!
    var siteNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        siteNumberLbl.text = ("\(wholeSite.siteNumber)")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("preparing fore segue")
            //let path = self.tableView.indexPathForSelectedRow?.row
            var vc = segue.destination as! SiteSectionsVC
            vc.theNum = 100
        
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        print("Hopefully first" )
        //UPDATE: Redis
        //dismiss(animated: true, completion: nil)
    }
}
