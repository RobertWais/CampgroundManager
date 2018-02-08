//
//  Site.swift
//  independentStudy
//
//  Created by Robert Wais on 2/8/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation


struct Site {
    private var _siteNumber: Int!
    private var _siteCleaned: Bool!
    private var _needWood: Bool!
    private var _complaint: Bool!
    private var _description: String!
    private var _timeFrame: String!
   
    
    init(siteNum: Int, siteClean: Bool, wood: Bool, complaintGiven: Bool, info: String, duration: String){
        self._siteNumber = siteNum
        self._siteCleaned = siteClean
        self._needWood = wood
        self._complaint = complaintGiven
        self._description = info
        self._timeFrame = duration
    }
    
    var siteNumber: Int {
        if _siteNumber == nil {
            _siteNumber = -1
        }
        return _siteNumber
    }
    
    var siteCleaned: Bool {
        if _siteCleaned == nil {
            _siteCleaned = false
        }
        return _siteCleaned
    }
    
    var needWood: Bool {
        if _needWood == nil {
            _needWood = false
        }
        return _needWood
    }
    
    var complaint: Bool {
        if _complaint == nil {
            _complaint = false
        }
        return _complaint
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    

}
