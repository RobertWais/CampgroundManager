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
    

    var tempWood = false
    var tempClean = false
    var mainColor = UIColor.white
    let myDelegate = UIApplication.shared.delegate as? AppDelegate
    var siteSelected: Site!
    var queryString: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        mainColor = submitBtn.backgroundColor!
        NotificationCenter.default.addObserver(self, selector: #selector(SiteSendVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SiteSendVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
        
        
       // descriptionSite.delegate = self
        /*
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50.0))
        numberToolbar.barStyle = UIBarStyle.default
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SiteSendVC.doneBtnPressed(_:)))
        let clearBtn = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SiteSendVC.clearTextView(_:)))
        
        numberToolbar.items = [space, clearBtn, space, doneBtn,space]
        numberToolbar.sizeToFit()
 */
        //descriptionSite.inputAccessoryView = numberToolbar
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
        //print("Clean: \(setClean.titleForSegment(at: setClean.selectedSegmentIndex))")
    }
    
    func submitTask(){
        toString()
        myDelegate?.redisManager.exec(command: (queryString!), completion: { (array) in
            print("Submitted")
            print(self.queryString!)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue")
        submitTask()
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
        print("Boolean: \(tempWood.description)")
        print("Duration \(setTimeStamp.titleForSegment(at: setTimeStamp.selectedSegmentIndex)!)")
        print("Description: \(descriptionSite.text!)")
        queryString = """
        HMSET site:\(siteSelected.siteNumber) cleaned \(tempClean.description) wood \(tempWood.description) duration \(setTimeStamp.titleForSegment(at: setTimeStamp.selectedSegmentIndex)!) description \(descriptionSite.text!)
        """
        print("Query: \(queryString!)")
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
