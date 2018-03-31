//
//  viewVC.swift
//  independentStudy
//
//  Created by Robert Wais on 3/29/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class viewVC: UIViewController, UIScrollViewDelegate {

    var image: UIImage?
    private var scrollView: UIScrollView!
    
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(touchedSection(recognizer:)))
        
        
        imageView = UIImageView(image:  image)
        imageView.isUserInteractionEnabled = true;
        imageView.addGestureRecognizer(recognizer)
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        scrollView.delegate = self
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        self.setZoomScale()
        
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

    override var prefersStatusBarHidden: Bool {
       return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //Code to toggle nav bar
    
    @objc func touchedSection(recognizer: UILongPressGestureRecognizer){
        /*
        if self.navigationController?.isNavigationBarHidden == true {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }else{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        */
    }
}
