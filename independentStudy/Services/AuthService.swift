//
//  AuthService.swift
//  independentStudy
//
//  Created by Robert Wais on 3/19/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation

import Foundation
import Firebase
import FirebaseStorage


class AuthService {
    static let instance = AuthService()
    private var _role: String?

    var role: String{
        if _role != nil{
            return _role!
        }
        return "no"
    }
    func loginUser(email: String, password:String, complete: @escaping (_ status: Bool, _ error: Error?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                complete(false,error)
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }else{
                print("Worked")
                DB_BASE.child("users").child((user?.uid)!).child("role").observe(DataEventType.value){ (data) in
                    let val = data.value as? String
                    self._role = val
                    print("ROLE: \(String(describing: val))")
                    complete(true,nil)
                }
                //var user = Auth.auth().currentUser
                //Check role
            }
        }
    }
}
