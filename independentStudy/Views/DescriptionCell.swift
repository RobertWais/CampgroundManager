//
//  DescriptionCell.swift
//  independentStudy
//
//  Created by Robert Wais on 3/24/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class DescriptionCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    func configureCell(imageAdd: UIImage){
    print("in description cell")
        self.imageView.image = imageAdd
    }
}
