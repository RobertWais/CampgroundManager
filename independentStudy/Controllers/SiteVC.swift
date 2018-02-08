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
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        //
        //self.performSegue(withIdentifier: "unwindToSiteSectionVC", sender: self)
        dismiss(animated: true, completion: nil)
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
