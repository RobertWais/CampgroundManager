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

    
    @IBOutlet var indicatoryView: UIActivityIndicatorView!
    
    
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var positionSelector: UISegmentedControl!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         indicatoryView.startAnimating()
        indicatoryView.hidesWhenStopped = true
        RedisCon.instance.connectRedis(){
            
            self.indicatoryView.stopAnimating()
        }
        
        //New
        ToastManager.shared.isTapToDismissEnabled = true
        signInBtn.layer.borderColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        signInBtn.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        if userNameField.text != nil && passwordTextField.text != nil{
            AuthService.instance.loginUser(email: userNameField.text!, password: passwordTextField.text!, complete: { (success, error)  in
                if success {
                    print("User Accepted")
                    self.performSegue(withIdentifier: "showMapVC", sender: self)
                }else{
                    
                    let alert = UIAlertController(title: "Error",
                                                  message: ((error?.localizedDescription)!),
                                                  preferredStyle: .alert)
                    
                    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
            })
    }
        
    func submitUser(){
       let query = positionSelector.titleForSegment(at: positionSelector.selectedSegmentIndex)?.lowercased()
        print("Query: \(query!)")
        
        RedisCon.instance.getArrayStatement(sections: "Get \(query!)") { (array) in
            let password = String(describing: array[0]);
            print("User: \(String(describing: array[0]))")
            if(password == self.passwordTextField.text!){
                user = self.positionSelector.selectedSegmentIndex+1
                print("USER: \(user)")
                self.performSegue(withIdentifier: "showMapVC", sender: self)
            }else{
                self.view.makeToast("WRONG PASSWORD", duration: 5.0, position: .top)
            }
        }
    }
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showMapVC"){
            print("Showing")
        }
    }
}
