//
//  Site.swift
//  independentStudy
//
//  Created by Robert Wais on 2/8/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation


struct Site {
    
    //
    //Change Later, Structs, vs Classes
    
    
    
    private var _dateAndTime: String!
    private var _siteNumber = ""
    private var _siteCleaned: Bool!
    private var _needWood: Bool!
    private var _complaint: Bool!
    private var _description: String!
    private var _timeFrame: String!
   
    
    init(siteNum: String, siteClean: Bool, wood: Bool, info: String, duration: String){
        _siteNumber = siteNum
        _siteCleaned = siteClean
        _needWood = wood
        _description = info
        _timeFrame = duration
    }
    
    var siteNumber: String {
        return _siteNumber
    }
    
    var siteCleaned: Bool {
        return _siteCleaned
    }
    
    var needWood: Bool {
        return _needWood
    }
    
    var description: String {
        return _description
    }
    
    var timeFrame: String {
        return _timeFrame
    }

}
