//
//  RedisCon.swift
//  independentStudy
//
//  Created by Robert Wais on 3/1/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import PSSRedisClient

class RedisCon: NSObject, RedisManagerDelegate {
    
    static let instance = RedisCon()
    private var redisManager: RedisClient!
    private var realManager: RedisClient!
    private var password: String?
    private var port: Int?
    private var URL: String?
    
    
    func connectRedis(){
        //Commented code is to be used soon, live database currently not ready.
    /*
        if let path = Bundle.main.path(forResource:"Connections", ofType: "plist"){
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                password = dict["Password"] as? String
                port = Int((dict["Port"] as? String)!)
                URL = dict["ConnectString"] as? String
            }
        }
    */
        
        
        /*
         realManager = RedisClient(delegate: self)
         realManager?.connect(host: URL!, port: port!, pwd: password!)
         realManager.exec(command: "PING") { (array) in
         print("Array: \(array[0])")
         }
         */
        
        
        redisManager = RedisClient(delegate: self)
        redisManager?.connect(host:"Localhost",
                                          port: 6379,
                                          pwd: "password")
        
       
    }
    
    
    func getArrayStatement(sections: String, completion: @escaping ([String])->()){
        if(redisManager.isConnected()){
            var returnArray = [String]()
            redisManager?.exec(command: sections, completion: { (array: NSArray!) in
                for index in 0..<array.count{
                    returnArray.append("\(array[index])")
                }
                completion(returnArray)
            })
        }
    }
    
    func clearSite(numString: String, completion: @escaping (Bool)->()){
        if(redisManager.isConnected()){
            redisManager?.exec(command: "HMSET site:\(numString) cleaned TRUE wood FALSE duration NONE description NONE", completion: { (array) in
                let returnCode = String(describing: array[0])
                print("Return code: \(returnCode)")
                if returnCode == "OK" {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    func getSiteInfo(number: String, site: String, completion: @escaping (Site)->()){
        redisManager?.exec(command: site, completion: { (array) in
            let cleaned = String(describing: array[1])
            let wood = String(describing: array[3])
            let duration = String(describing: array[5])
            let description = String(describing: array[7])
            var boolWood = false
            var boolClean = false
            
            if cleaned == "TRUE" {
                boolClean = true
            }else{
                boolClean = false
            }
            if wood == "TRUE" {
                boolWood = true
            }else{
                boolWood = false
            }
            
            let tempSite = Site(siteNum: number, siteClean: boolClean, wood: boolWood, info: description, duration: duration)
            completion(tempSite)
            
        })
    }
    
    
    
    func subscriptionMessageReceived(channel: String, message: String) {
        print("Yup")
    }
    
    func socketDidDisconnect(client: RedisClient, error: Error?) {
        print("Disconnecting")
        print("Error: \(error?.localizedDescription)")
    }
    
    func socketDidConnect(client: RedisClient) {
        
        print("Connected..")
    }
    
    
    
    
}
