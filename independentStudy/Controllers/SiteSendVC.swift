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

    
    @IBOutlet var siteNumberLbl: UILabel!
    @IBOutlet var setClean: UISegmentedControl!
    @IBOutlet var setTimeStamp: UISegmentedControl!
    @IBOutlet var setWood: UISegmentedControl!
    @IBOutlet var descriptionSite: UITextView!
    
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        print("Clean: \(setClean.titleForSegment(at: setClean.selectedSegmentIndex))")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        NotificationCenter.default.addObserver(self, selector: #selector(SiteSendVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SiteSendVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    */
        
        
        descriptionSite.delegate = self
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50.0))
        numberToolbar.barStyle = UIBarStyle.default
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SiteSendVC.doneBtnPressed(_:)))
        let clearBtn = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SiteSendVC.clearTextView(_:)))
        
        numberToolbar.items = [space, clearBtn, space, doneBtn,space]
        numberToolbar.sizeToFit()
        //descriptionSite.inputAccessoryView = numberToolbar
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneBtnPressed(_ sender: UIBarButtonItem){
        descriptionSite.endEditing(true)
    }
    @objc func clearTextView(_ sender: UIBarButtonItem){
        descriptionSite.text = ""
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
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
