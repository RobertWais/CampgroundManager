//
//  DataService.swift
//  independentStudy
//
//  Created by Robert Wais on 3/19/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()


class DataService {
    static let instance = DataService()
    
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_REDIS = DB_BASE.child("redis")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_REDIS: DatabaseReference {
        return _REF_REDIS
    }
}
