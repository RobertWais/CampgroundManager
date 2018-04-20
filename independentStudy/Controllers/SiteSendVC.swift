//
//  SiteSendVC.swift
//  independentStudy
//
//  Created by Robert Wais on 2/17/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase
class SiteSendVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    //@IBOutlet var progressCounter: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var siteNumberLbl: UILabel!
    @IBOutlet var setClean: UISegmentedControl!
    @IBOutlet var setTimeStamp: UISegmentedControl!
    @IBOutlet var setWood: UISegmentedControl!
    @IBOutlet var descriptionSite: UITextView!
    @IBOutlet weak var collection: UICollectionView!
    
    private var selectedImage = -1
    private var sortedArray = [String]()
    private var images = [UIImage]()
    private var tempWood = false
    private var tempClean = false
    private var mainColor = UIColor.white
    var siteSelected: Site!
    private var queryString: String!
    private let layer = CAShapeLayer()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.layer.cornerRadius = progressBar.frame.height/2
        progressBar.layer.masksToBounds = true
        collection.dataSource = self
        collection.delegate = self
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
    }
    
    //MARK: Redis Command
    func submitTask(){
        toString()
        var sendArray = [String]()
        sendArray.append("HMSET")
        sendArray.append("site:\(siteSelected.siteNumber)")
        sendArray.append("Cleaned")
        sendArray.append(sortedArray[0])
        sendArray.append("Wood")
        sendArray.append(sortedArray[1])
        sendArray.append("Duration")
        sendArray.append(sortedArray[2])
        sendArray.append("Description")
        sendArray.append(sortedArray[3])
        RedisCon.instance.setStatement(arr: sendArray, completion: { (array) in
            
            let returnCode = String(describing: array[0])
            print("Return code: \(returnCode)")
            if returnCode == "OK" {
                
                self.saveAll(index: 0){ (ok) in
                        if ok {
                            self.performSegue(withIdentifier: "unwindFromSendVC", sender: self)
                        } else{
                            print("Error")
                        }
                }
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
    
    func saveAll(index: Int, completion: @escaping (Bool)->()) {
        var num = index
        
        //Base case
        if(num >= images.count){
            completion(true)
        } else {
            saveImages(index: num){ (tru) in
                if tru {
                    self.saveAll(index: num+1) { (tru) in
                        if tru {
                            completion(true)
                        }
                    }
                } else{
                    completion(false)
                }
            }
        }
    }
    //MARK: FIrebase saving to storage
    
    func saveImages(index: Int,completion:@escaping (Bool)->()){
        var worked = true;
        let storage = Storage.storage()
                let data = UIImageJPEGRepresentation(self.images[index], 0.8)
                    //UIImagePNGRepresentation(self.images[index])
        
                let uploadMetadata = StorageMetadata()
                uploadMetadata.contentType = "image/jpeg"
                let pathReference = storage.reference(withPath: "SiteImages/Site\(self.siteSelected.siteNumber)/image\(index).jpg")
                
                let uploadTask = pathReference.putData(data!, metadata: uploadMetadata) { (metadata, error) in
                    if error == nil {
                        print("Success")
                        completion(true)
                    } else {
                        completion(false)
                        print("Error \(error?.localizedDescription)")
                    }
                }
                
                uploadTask.observe(.progress) { snapshot in
                    // Upload reported progress
                    self.layer.sublayers = nil
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                        / Double(snapshot.progress!.totalUnitCount)
                    
                    let progress = CGRect(x: 0, y: 0, width: self.progressBar.frame.width * (CGFloat(percentComplete) * 0.01), height: self.progressBar.frame.height)
                    
                    let bez = UIBezierPath(roundedRect: progress, cornerRadius: self.progressBar.frame.height/2 )
                    
                    self.layer.path = bez.cgPath
                    if (index % 2 == 0){
                        self.layer.fillColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1).cgColor
                    }else{
                        self.layer.fillColor = UIColor.black.cgColor
                    }
                    
                    self.progressBar.layer.addSublayer(self.layer)
                    print("Progress \(percentComplete)")
                }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewImage"){
            let vc = segue.destination as! viewVC
            vc.image = images[selectedImage]
            //Emptying array elements]
        }
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
        sortedArray.append(tempClean.description.uppercased())
        sortedArray.append(tempWood.description.uppercased())
        sortedArray.append(setTimeStamp.titleForSegment(at: setTimeStamp.selectedSegmentIndex)!)
        sortedArray.append(descriptionSite.text!)
    }
    //
    //MARK: KEYBOARD FUNCTIONS
    //
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                submitBtn.backgroundColor = UIColor.black
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        print("Heappends")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                submitBtn.backgroundColor = mainColor
        }
    }
    
    //MARK: Collection Views
    
    //Takes each image that is in the array to be shown and displays it
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescCell", for: indexPath) as? DescriptionCell {
            let image = images[indexPath.row]
            cell.configureCell(imageAdd: image)
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item")
        selectedImage = indexPath.row
        self.performSegue(withIdentifier: "viewImage", sender: self)
        //create a alert controller to delete image
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension SiteSendVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionSite.text == "NONE" {
            descriptionSite.text = ""
        }
    }
}

extension SiteSendVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //Is called if the user selects an image from
    //either ImagePickerControllers
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let shownImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if shownImage != nil {
            images.append(shownImage)
            collection.reloadData()
        }
    }
    
    //The action allows user to take a photo, select a phot from photo library or cancel.
     @IBAction func cameraPressed(_ sender: UIButton){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        let alert = UIAlertController(title: "Select Image Option", message: "", preferredStyle: .alert)
        
        
        let optionCamera = UIAlertAction(title: "Take a Photo", style: .default) { (option) in
            imagePicker.sourceType = .camera
            self.present(imagePicker,animated:  true, completion: nil)
        }
        let optionPhotoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (option) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker,animated:  true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addAction(optionCamera)
        alert.addAction(optionPhotoLibrary)
        alert.addAction(cancelAction)
        self.present(alert,animated: true)
    }
}


    


