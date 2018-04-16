//
//  SiteVC.swift
//  independentStudy
//
//  Created by Robert Wais on 2/7/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import Firebase

class SiteVC: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {

    var siteSection: String?
    var wholeSite: Site!
    var image: UIImage?
    private var images = [UIImage]()
    private var selectedImage = -1
    
    @IBOutlet var testImageView: UIImageView!
    @IBOutlet var siteNumberLbl: UILabel!
    @IBOutlet var siteCleaned: UILabel!
    @IBOutlet var needWood: UILabel!
    @IBOutlet var timeStamp: UILabel!
    @IBOutlet var collection: UICollectionView!
    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Looking for this: \(siteSection)")
        updateUI()
        collection.dataSource = self
        collection.delegate = self
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
            needWood.text = "❌"
        } else {
            needWood.text = "✅"
        }
        timeStamp.text = wholeSite.timeFrame
        textView.text = wholeSite.description
        getAll(index: 0) { (bool) in
            if bool {
                print("worked")
            }else{
                print("error")
            }
        }
        
    }
    
    func deleteImages(handler: @escaping (Bool)->()){
        if(images.count == 0){
            handler(true)
        }
        for index in 0..<images.count {
            let reference = Storage.storage().reference(withPath: "SiteImages/Site\(wholeSite.siteNumber)/image\(index).jpg")
            reference.delete(completion: { (error) in
                if error == nil{
                    print("Deleted Files")
                    handler(true)
                }else{
                    print("Error: \(String(describing: error?.localizedDescription))")
                    handler(false)
                }
            })
        }
        
    }
    
    func getImages(index: Int,completion: @escaping (Bool)->()) {
        print("Index: \(index)")
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: "SiteImages/Site\(wholeSite.siteNumber)/image\(index).jpg")
        print("path ref: \(pathReference)")
        pathReference.getData(maxSize: 2500000) { (data, error) in
            if let error = error{
                print("Error: \(error)")
                completion(false)
            }else{
                print("tru in get images")
                let tempImage = UIImage(data: data!)
                self.images.append(tempImage!)
                self.collection.reloadData()
                completion(true)
            }
        }
    }
    
    func getAll(index: Int, completion: @escaping (Bool)->()) {
        let num = index
        getImages(index: num){ (tru) in
                if tru {
                    self.getAll(index: num+1) { (tru) in
                        if tru {
                            completion(true)
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewImage"){
            let vc = segue.destination as! viewVC
            vc.image = images[selectedImage]
        }
        
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Completed Task",
                                      message: "Have you completed everything in the task?",
                                      preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            RedisCon.instance.clearSite(numString: self.siteNumberLbl.text!) { (noError) in
                if noError{
                    self.deleteImages(){ (ok) in
                        if ok {
                            
                            RedisCon.instance.removeAlertSites(siteSection: self.siteSection! , site: self.wholeSite.siteNumber, completion: { (removed) in
                                self.performSegue(withIdentifier: "unwindSegue", sender: self)
                            })
                            
                            
                            
                        }else{
                            self.errorAlert()
                        }
                    }
                    
                }else{
                    alert.dismiss(animated: false, completion: {
                    })
                    self.errorAlert()
                }
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    //
    //MARK: Collection View
    //-Will eventually put to extension but was having previous problems
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescCell", for: indexPath) as? DescriptionCell {
            cell.configureCell(imageAdd: images[indexPath.row])
            return cell
        }else{
            print("Here it is")
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
    
    func errorAlert(){
        let errorAlert = UIAlertController(title: "Error",
                                           message: "Could not complete site, please try again.",
                                           preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        errorAlert.addAction(cancelAction)
        self.present(errorAlert,animated: true, completion: nil)
    }
    
    
    
}
