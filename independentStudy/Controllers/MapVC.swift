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
    
    private var array: NSArray!
    private var allLayers = [String: CAShapeLayer]()
    private var sectionsNames = [String]()
    private var findLayer = [CAShapeLayer]()
    private var selectedSection: String?
    var readSiteNumbers = [String]()
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var AlertSections = Set<String>()
    var preLoaded = false
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View will appear--------------------------")
        displaySites()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("YES----------------------------")
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    override func viewDidLoad() {
        newWay()
        print("View did load")
        super.viewDidLoad()
        preLoaded = true
        /*
         Setup Recognizer for taps
         */
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(touchedSection(recognizer:)))
        /*
         Setup Recognizer for taps
         */
        imageView = UIImageView(image:  #imageLiteral(resourceName: "campsite_map-1"))
        imageView.isUserInteractionEnabled = true;
        imageView.addGestureRecognizer(recognizer)
        print("Width: \(imageView.bounds.width)")
        print("Length: \(imageView.bounds.height)")
                print("Loaded user: \(AuthService.instance.role)")
        //Setup Image View
        createLayers()
        //ScrollView Initialization
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.clear
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        scrollView.delegate = self
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        self.setZoomScale()
    }
    
    //MARK: Displaying Sites
    
    //USED for setting all sites, testing purposes
    func initSites(){
        for index in 1..<533 {
            RedisCon.instance.getArrayStatement(sections: "HMSET site:\(index) Cleaned TRUE Wood FALSE Duration NONE Description NONE"
                , completion: { (array) in
                    print("Worked?: \(array[0])")
            })
        }
    }
    
    func displaySites(){
        RedisCon.instance.getFullSections(sections: sectionsNames) { (array) in
            for index in 0..<array.count{
                print("Alert: \(array[index])")
                self.AlertSections.insert(array[index])
            }
            for index in 0..<self.findLayer.count{
                if self.AlertSections.contains(self.findLayer[index].name!){
                    self.findLayer[index].fillColor = UIColor(red:100, green:0.0, blue:0.0, alpha: 0.5).cgColor
                }else{
                    self.findLayer[index].fillColor = UIColor(red:0.0, green:0.0, blue:100.0, alpha: 0.5).cgColor
                }
            }
        }
        /*
        RedisCon.instance.getAlertSections { (array) in
            //update UI
            self.AlertSections.removeAll(keepingCapacity: false)
            for index in 0..<array.count {
                print("Updated:")
                self.AlertSections.insert(array[index])
            }
            for index in 0..<self.findLayer.count{
                if self.AlertSections.contains(self.findLayer[index].name!){
                    self.findLayer[index].fillColor = UIColor(red:100, green:0.0, blue:0.0, alpha: 0.5).cgColor
                }else{
                    self.findLayer[index].fillColor = UIColor(red:0.0, green:0.0, blue:100.0, alpha: 0.5).cgColor
                }
            }
        }
        */
    }
    
    func newWay(){
        let sites = ["SS1_SS12","SS13_SS14"]
        RedisCon.instance.getFullSections(sections: sites) { (array) in
            for index in 0..<array.count{
                print("Alert: \(array[index])")
            }
        }
    }
    func getColor(site: String)->UIColor{
        if AlertSections.contains(site){
            return UIColor(red:100, green:0.0, blue:0.0, alpha: 0.5)
        } else {
            return UIColor(red:0.0, green:0.0, blue:100.0, alpha: 0.5)
        }
        
    }
    
    func createLayers(){
        createLayer(pathstring: sites155_162, color: getColor(site: "SS155_SS162").cgColor, name: "SS155_SS162")
        createLayer(pathstring: sites170_171, color: getColor(site: "SS170_SS171").cgColor, name: "SS170_SS171")
        createLayer(pathstring: sites448_452, color: getColor(site: "SS448_SS452").cgColor, name: "SS448_SS452")
        createLayer(pathstring: sites445_447, color: getColor(site: "SS445_SS447").cgColor, name: "SS445_SS447")
        createLayer(pathstring: sites163_169, color: getColor(site: "SS163_SS169").cgColor, name: "SS163_SS169")
        createLayer(pathstring: sites106_111, color: getColor(site: "SS106_SS111").cgColor, name: "SS106_SS111")
        createLayer(pathstring: sites102_105, color: getColor(site: "SS102_SS105").cgColor, name: "SS102_SS105")
        createLayer(pathstring: sites138_147, color: getColor(site: "SS138_SS147").cgColor, name: "SS138_SS147")
        createLayer(pathstring: sites238_249, color: getColor(site: "SS238_SS249").cgColor, name: "SS238_SS249")
        createLayer(pathstring: sites33_40, color: getColor(site: "SS33_SS40").cgColor, name: "SS33_SS40")
        createLayer(pathstring: sites1_12, color: getColor(site: "SS1_SS12").cgColor, name: "SS1_SS12")
        createLayer(pathstring: sites405_414, color: getColor(site: "SS405_SS414").cgColor, name: "SS405_SS414")
        createLayer(pathstring: sites425_434, color: getColor(site: "SS425_SS434").cgColor, name: "SS425_SS434")
        createLayer(pathstring: sites435_444, color: getColor(site: "SS435_SS444").cgColor, name: "SS435_SS444")
        createLayer(pathstring: sites13_23, color: getColor(site: "SS13_SS23").cgColor, name: "SS13_SS23")
        createLayer(pathstring: sites415_424, color: getColor(site: "SS415_SS424").cgColor, name: "SS415_SS424")
        createLayer(pathstring: BACK_BATHHOUSE, color: getColor(site: "BACK_BATHHOUSE").cgColor, name: "BACK_BATHHOUSE")
    }
    
    func createLayer(pathstring: String, color: CGColor, name: String){
        let layer = CAShapeLayer()
        let temp = UIBezierPath(pathString: pathstring)
        layer.path = temp.cgPath
        layer.fillColor = color
        layer.name = name
        layer.value(forKeyPath: name)
        findLayer.append(layer)
        allLayers[layer.name!]=layer
        imageView.layer.addSublayer(layer)
        sectionsNames.append(name)
    }
    
    @objc func touchedSection(recognizer: UITapGestureRecognizer){
        let destination:CGPoint = recognizer.location(in: recognizer.view)
        let query = findLayerTouched(destination: destination)
        
        //print("Querying \(query)")
        if (query != "") {
            print("query: \(query)")
            RedisCon.instance.getArrayStatement(sections: "SMEMBERS \(query)", completion: { (array) in
                print("In new call...")
                self.readSiteNumbers = array
                self.selectedSection = query
                self.performSegue(withIdentifier: "show", sender: self)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "show"){
            let vc = segue.destination as! SiteSectionsVC
            vc.numberSite = readSiteNumbers
            vc.siteSection = self.selectedSection
            
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
        let zoomScale = min(self.view.bounds.size.width / (self.imageView.image?.size.width)!, self.view.bounds.size.height / (self.imageView.image?.size.height)!);
        
        if (zoomScale > 1) {
            self.scrollView.minimumZoomScale = 1;
        }
        
        self.scrollView.minimumZoomScale = zoomScale;
        self.scrollView.zoomScale = zoomScale;
        self.scrollView.maximumZoomScale = 5.0
    }
}




