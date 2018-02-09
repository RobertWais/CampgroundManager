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
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    let shapesLayer = CAShapeLayer()
    let lakeLayer = CAShapeLayer()
    let siteLayer = CAShapeLayer()
    
    var redisManager: RedisClient!
    var subscriptionManager: RedisClient!
    
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
        
        //hide nav bar
        
        
        self.redisManager = RedisClient(delegate: self)
        self.subscriptionManager = RedisClient(delegate: self)
        self.redisManager?.connect(host:"169.254.246.180",
                                   port: 6379,
                                   pwd: "password")
        self.subscriptionManager?.connect(host: "169.254.246.180",
                                          port: 6379,
                                          pwd: "password")
        
        redisManager.exec(command: "GET user", completion:
            { (array: NSArray!) in
                print("User is \(array[0])")
                // this is where the completion handler code goes
                
        } )
        
        /*
         Setup Recognizer for taps
         */
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(touchedSection(recognizer:)))
        /*
         Setup Recognizer for taps
         */
        
        let shapes = BACK_BATHHOUSE
        let shapePath = UIBezierPath(pathString: shapes)
        shapesLayer.path = shapePath.cgPath
        shapesLayer.fillColor = UIColor(red:200.0, green:0.0, blue:0.0, alpha:0.2).cgColor
      
        
        let lake = LAKE
        let lakePath = UIBezierPath(pathString: lake)
        lakeLayer.path = lakePath.cgPath
        lakeLayer.fillColor = UIColor(red:100, green:0.0, blue:0.0, alpha: 0.5).cgColor
        
        let section = sites419
        let sectionPath = UIBezierPath(pathString: section)
        siteLayer.path = sectionPath.cgPath
        siteLayer.fillColor = UIColor(red:100, green:0.0, blue:0.0, alpha: 0.5).cgColor
        siteLayer.borderColor = UIColor(red:0, green:0.0, blue:0.0, alpha: 1.0).cgColor
        
        
        //Setup Image View
        imageView = UIImageView(image:  #imageLiteral(resourceName: "campsite_map"))
        imageView.layer.addSublayer(shapesLayer)
        imageView.layer.addSublayer(lakeLayer)
        imageView.layer.addSublayer(siteLayer)
        imageView.isUserInteractionEnabled = true;
        imageView.addGestureRecognizer(recognizer)
        print("Width: \(imageView.bounds.width)")
            print("Length: \(imageView.bounds.height)")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    @objc func touchedSection(recognizer: UITapGestureRecognizer){
       
        let destination:CGPoint = recognizer.location(in: recognizer.view)
        
        
        
        if((shapesLayer.path?.contains(destination))! || (siteLayer.path?.contains(destination))!) {
            print("black death")
            performSegue(withIdentifier: "show", sender: self)
        }
        
        if destination.x < 196 && destination.x > 175 && destination.y > 325 && destination.y < 541{
            self.view.makeToast("Querying 46-60", duration: 1.5, position: .bottom)
        } else if destination.x < 306 && destination.x > 220 && destination.y > 234 && destination.y < 285  {
            self.view.makeToast("Querying Pool", duration: 1.5, position: .bottom)
        }
    }
    
    func setPaths(stringPath: String){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "show"){
            //let path = self.tableView.indexPathForSelectedRow?.row
            var vc = segue.destination as! SiteSectionsVC
            vc.num = 10
        }
    }
    


}


extension MapVC: RedisManagerDelegate {
    func subscriptionMessageReceived(channel: String, message: String) {
        debugPrint("Disconnected (Error: \(message))")

    }
    
    func socketDidDisconnect(client: RedisClient, error: Error?) {
        debugPrint("Disconnected (Error: \(error?.localizedDescription))")

    }
    
    func socketDidConnect(client: RedisClient) {
        //debugPrint("SOCKET: Connected")
        // Setup a subscription after we have connected
    }
}





