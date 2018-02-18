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
    @IBOutlet var siteCleaned: UILabel!
    @IBOutlet var needWood: UILabel!
    @IBOutlet var timeStamp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
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

    func updateUI(){
        siteNumberLbl.text = wholeSite.siteNumber
        if(wholeSite.siteCleaned){
            siteCleaned.text = "✅"
        } else {
            siteCleaned.text = "❌"
        }
        if(wholeSite.needWood){
            needWood.text = "✅"
        } else {
            needWood.text = "❌"
        }
        timeStamp.text = wholeSite.timeFrame
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("preparing fore segue")
            //let path = self.tableView.indexPathForSelectedRow?.row
            var vc = segue.destination as! SiteSectionsVC
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        print("Hopefully first" )
        //UPDATE: Redis
        //dismiss(animated: true, completion: nil)
    }
}
