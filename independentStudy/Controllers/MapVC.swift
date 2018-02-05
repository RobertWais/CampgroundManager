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

var scrollView: UIScrollView!
var imageView: UIImageView!


let layer = CAShapeLayer()
let layer2 = CAShapeLayer()

class MapVC: UIViewController,UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         Setup Recognizer for taps
         */
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(touchedSection(recognizer:)))
        /*
         Setup Recognizer for taps
         */
        
        
        
    
   let fun = "M -2.8571386,379.6198 V 1.048369 H 298.57143 600 V 379.6198 758.19123 H 298.57143 -2.8571386 Z M 408.57143,333.90551 v -27.14286 h -55.71428 -55.71429 v 27.14286 27.14286 h 55.71429 55.71428 z"
        let funPath = CAShapeLayer(pathString: fun)
        funPath.fillColor = UIColor.yellow.cgColor
        funPath.borderColor = UIColor.blue.cgColor
        funPath.transform = CATransform3DMakeScale(0.75, 0.75, 1)
        
        /*
         Creating Layers
         */
        let attempt = "M 145.71429,519.94826 V 118.51969 H 254.28571 362.85714 V 519.94826 921.37683 H 254.28571 145.71429 Z"
        let path = CAShapeLayer(pathString: attempt)
        print("here")
        path.fillColor = UIColor.red.cgColor
        path.position = CGPoint(x: 0, y: 0)
        
        let attemptTwo = "M 2.8571429,451.94826 V 1.9482565 h 189.9999971 190 v 450.0000035 450 h -190 H 2.8571429 Z"
        let pathTwo = CAShapeLayer(pathString: attemptTwo)
        path.fillColor = UIColor.blue.cgColor
        path.position = CGPoint(x:0, y: 0)
        
        
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 20, height: 215), cornerRadius: 0).cgPath
        layer.fillColor = UIColor.red.cgColor
        layer.opacity = 0.5
        layer.position = CGPoint(x: 175 , y: 325)
        ///////////////////////////////////////////
        layer2.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 85, height: 40), cornerRadius: 10).cgPath
        layer2.fillColor = UIColor.blue.cgColor
        layer2.opacity = 0.5
        layer2.position = CGPoint(x: 220 , y: 235)
        /*
         Creating Layers
         */
        
        //Setup Image View
        imageView = UIImageView(image:  #imageLiteral(resourceName: "campsite_map"))
        imageView.layer.addSublayer(layer)
        imageView.layer.addSublayer(layer2)
        imageView.layer.addSublayer(path)
        imageView.layer.addSublayer(funPath)
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
        print("Zoom scale: \(verticalPadding)")
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
        if destination.x < 196 && destination.x > 175 && destination.y > 325 && destination.y < 541{
            self.view.makeToast("Querying 46-60", duration: 1.5, position: .bottom)
        } else if destination.x < 306 && destination.x > 220 && destination.y > 234 && destination.y < 285  {
            self.view.makeToast("Querying Pool", duration: 1.5, position: .bottom)
        }
    }
    


}

