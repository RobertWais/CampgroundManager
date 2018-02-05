//
//  SiteTableCell.swift
//  independentStudy
//
//  Created by Robert Wais on 2/5/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class SiteTableCell: UITableViewCell {
    
    @IBOutlet var siteLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(siteName: String, timeFrame: String){
        self.siteLbl.text = siteName
        self.siteLbl.text = timeFrame
    }
}
