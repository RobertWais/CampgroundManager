//
//  SignInVC.swift
//  independentStudy
//
//  Created by Robert Wais on 2/22/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet var positionSelector: UISegmentedControl!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        //Check redis set for the given value
        //Either Employee/Manager
        
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
