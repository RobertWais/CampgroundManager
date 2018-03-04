//
//  SiteSendVC.swift
//  independentStudy
//
//  Created by Robert Wais on 2/17/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import NotificationCenter
class SiteSendVC: UIViewController {

    
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var siteNumberLbl: UILabel!
    @IBOutlet var setClean: UISegmentedControl!
    @IBOutlet var setTimeStamp: UISegmentedControl!
    @IBOutlet var setWood: UISegmentedControl!
    @IBOutlet var descriptionSite: UITextView!
    

    private var tempWood = false
    private var tempClean = false
    private var mainColor = UIColor.white
    var siteSelected: Site!
    private var queryString: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        mainColor = submitBtn.backgroundColor!
        NotificationCenter.default.addObserver(self, selector: #selector(SiteSendVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SiteSendVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    func updateUI(){
        siteNumberLbl.text = siteSelected.siteNumber
        if(siteSelected.siteCleaned){
            setClean.selectedSegmentIndex = 1
        }else{
            setClean.selectedSegmentIndex = 0
        }
        if(siteSelected.needWood){
            setWood.selectedSegmentIndex =  1
        }else{
            setWood.selectedSegmentIndex =  0
        }
        //*CHANGE LATER
        setTimeStamp.selectedSegmentIndex = 1
        descriptionSite.text = siteSelected.description
        print("Here: \(siteSelected.timeFrame)")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func doneBtnPressed(_ sender: UIBarButtonItem){
        descriptionSite.endEditing(true)
    }
    @objc func clearTextView(_ sender: UIBarButtonItem){
        descriptionSite.text = ""
    }

    @IBAction func submitBtnPressed(_ sender: Any) {
        submitTask()
        //print("Clean: \(setClean.titleForSegment(at: setClean.selectedSegmentIndex))")
    }
    
    func submitTask(){
        toString()
        RedisCon.instance.getArrayStatement(sections: (queryString!), completion: { (array) in
            
            let returnCode = String(describing: array[0])
            print("Return code: \(returnCode)")
            if returnCode == "OK" {
                self.performSegue(withIdentifier: "unwindFromSendVC", sender: self)
            }else{
                let alert = UIAlertController(title: "Error",
                                              message: "Data could not be entered, try again",
                                              preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing for segue")
        
        //submitTask()
        //let path = self.tableView.indexPathForSelectedRow?.row
    }
    
    func toString(){
        if(setClean.titleForSegment(at: setClean.selectedSegmentIndex)! == "Dirty"){
            tempClean = false
        }else{
            tempClean = true
        }
        if(setWood.titleForSegment(at: setWood.selectedSegmentIndex)! == "No"){
            tempWood = false
        }else{
            tempWood = true
        }
        print("HERE: \(tempWood.description.uppercased())")
        queryString = """
        HMSET site:\(siteSelected.siteNumber) cleaned \(tempClean.description.uppercased()) wood \(tempWood.description.uppercased()) duration \(setTimeStamp.titleForSegment(at: setTimeStamp.selectedSegmentIndex)!) description \(descriptionSite.text!)
        """
    }
    
    
    
    
    //
    //MARK: KEYBOARD FUNCTIONS
    //
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                submitBtn.backgroundColor = UIColor.black
                //self.view.frame.origin.y -= keyboardSize.height
            
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                submitBtn.backgroundColor = mainColor
                //self.view.frame.origin.y += keyboardSize.height
            
        }
    }
}

extension SiteSendVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionSite.text == "Describe the task at hand..." {
            descriptionSite.text = ""
        }
    }
}
