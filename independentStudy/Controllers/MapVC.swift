//
//  ViewController.swift
//  independentStudy
//
//  Created by Robert Wais on 2/1/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftSVG
import PSSRedisClient




class MapVC: UIViewController,UIScrollViewDelegate {
    
    var array: NSArray!
    var findLayer = [CAShapeLayer]()
    var readSiteNumbers = [String]()
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    let Back_BathhouseLayer = CAShapeLayer()
    let lakeLayer = CAShapeLayer()
    let sites415_424Layer = CAShapeLayer()
    let sites13_23Layer = CAShapeLayer()
    let sites405_414Layer = CAShapeLayer()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RedisCon.instance.getArrayStatement(sections: "SMEMBERS ALERT_SECTIONS") { (array) in
            for index in 0..<array.count {
                print("These sections need to be worked on: \(array[index])")
            }
        }
        /*
         Setup Recognizer for taps
         */
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(touchedSection(recognizer:)))
        /*
         Setup Recognizer for taps
         */
        
        //Setup Image View
        imageView = UIImageView(image:  #imageLiteral(resourceName: "campsite_map"))
        
        createLayer(pathstring: sites405_414, color: UIColor(red:100, green:0.0, blue:0.0, alpha: 0.5).cgColor, name: "SS405_414")
        createLayer(pathstring: sites13_23, color: UIColor(red:100, green:0.0, blue:0.0, alpha: 0.5).cgColor, name: "SS13_23")
        createLayer(pathstring: sites415_424, color: UIColor(red:100, green:0.0, blue:0.0, alpha: 0.5).cgColor, name: "SS415_424")
        createLayer(pathstring: BACK_BATHHOUSE, color: UIColor(red:200.0, green:0.0, blue:0.0, alpha:0.2).cgColor, name: "BACK_BATHHOUSE")
        createLayer(pathstring: LAKE, color: UIColor(red:100, green:0.0, blue:0.0, alpha: 0.5).cgColor, name: "LAKE")
        
        //imageView.layer.addSublayer(sites405_414Layer)
        imageView.layer.addSublayer(sites13_23Layer)
        imageView.layer.addSublayer(Back_BathhouseLayer)
        imageView.layer.addSublayer(lakeLayer)
        imageView.layer.addSublayer(sites415_424Layer)
        imageView.isUserInteractionEnabled = true;
        imageView.addGestureRecognizer(recognizer)
        print("Width: \(imageView.bounds.width)")
        print("Length: \(imageView.bounds.height)")
        
        
        //Add Layers to list
        findLayer.append(sites415_424Layer)
        findLayer.append(sites13_23Layer)
        //findLayer.append(sites405_414Layer)
        //
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.clear
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        scrollView.delegate = self
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        
        self.setZoomScale()
        //HACK -- change later
        
        scrollView.setZoomScale(0.1, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func createLayer(pathstring: String, color: CGColor, name: String){
        let layer = CAShapeLayer()
        let temp = UIBezierPath(pathString: pathstring)
        layer.path = temp.cgPath
        layer.fillColor = color
        layer.name = name
        findLayer.append(layer)
        imageView.layer.addSublayer(layer)
    }
    
    /*
    func getSitesForSection(section: String, completion: @escaping (Bool)->Void){
        print("Started function")
        AppDelegate.redisManager.exec(command: "SMEMBERS \(section)", completion:
            { (array: NSArray!) in
                for index in 0..<array.count {
                    print("Adding value for next VC: \(array[index])")
                    self.readSiteNumbers.append("\(array[index])")
                }
                //All alert sites will be read in right away
                //Create the site with an alert- <TRUE/FALSE> if there is alert, display cell as red
                //TEST AGAINST ALL SITES THAT ARE RED
                completion(true)
        })
    }
    */
    
    @objc func touchedSection(recognizer: UITapGestureRecognizer){
        let destination:CGPoint = recognizer.location(in: recognizer.view)
        let query = findLayerTouched(destination: destination)
        
        //print("Querying \(query)")
        if (query != "") {
            RedisCon.instance.getArrayStatement(sections: "SMEMBERS \(query)", completion: { (array) in
                print("In new call...")
                self.readSiteNumbers = array
                self.performSegue(withIdentifier: "show", sender: self)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "show"){
            let vc = segue.destination as! SiteSectionsVC
            vc.numberSite = readSiteNumbers
            
            //Emptying array elements
            readSiteNumbers.removeAll(keepingCapacity: false)
        }
    }
    
    
    //Finds which layer the user touched
    func findLayerTouched(destination: CGPoint) -> String {
        for index in 0..<findLayer.count{
            if (findLayer[index].path?.contains(destination))!{
                return findLayer[index].name!
            }
        }
        return ""
    }

    
    
    //MARK: ScrollView settings
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
}





