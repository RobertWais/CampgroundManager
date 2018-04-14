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
    var siteNum = ""
    var type = ""
    var cellSite: Site!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(site: Site, alert: Bool){
        self.siteLbl.text = site.siteNumber
        self.typeLbl.text = site.timeFrame
        cellSite = site
        if alert {
            self.backgroundColor = UIColor.red
        } else{
            self.backgroundColor = UIColor.white
        }
    }
}
