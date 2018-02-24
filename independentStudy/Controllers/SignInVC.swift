//
//  SignInVC.swift
//  independentStudy
//
//  Created by Robert Wais on 2/22/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import SwiftSVG
import Toast_Swift

class SignInVC: UIViewController {

    @IBOutlet var positionSelector: UISegmentedControl!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    let myDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ToastManager.shared.isTapToDismissEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        //Check redis set for the given value
        //Either Employee/Manager
        submitUser()
        
    }
    
    func submitUser(){
       var query = positionSelector.titleForSegment(at: positionSelector.selectedSegmentIndex)?.lowercased()
        print("Query: \(query!)")
        myDelegate?.redisManager.exec(command: "GET \(query!)", completion:
            { (array: NSArray!) in
                //print("User is \(array[0])")
                let password = String(describing: array[0]);
                print("User: \(String(describing: array[0]))")
                if(password == self.passwordTextField.text!){
                    print("Let them pass")
                    self.performSegue(withIdentifier: "showMapVC", sender: self)
                }else{
                    self.view.makeToast("WRONG PASSWORD", duration: 5.0, position: .top)
                }
                // this is where the completion handler code goes
                
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if(segue.identifier == "showMapVC"){
        print("Showing")
        }
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
