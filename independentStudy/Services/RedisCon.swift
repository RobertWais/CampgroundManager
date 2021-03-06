//
//  RedisCon.swift
//  independentStudy
//
//  Created by Robert Wais on 3/1/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import PSSRedisClient
import Firebase

class RedisCon: NSObject, RedisManagerDelegate {
    
    static let instance = RedisCon()
    private var redisManager: RedisClient!
    private var realManager: RedisClient!
    private var password: String?
    private var port: Int?
    private var URL: String?
    private var url: String?
    private var port2: String?
    
    
    func connectRedis(completion: @escaping ()->()){
        print("Connecting Redis")
        DataService.instance.REF_REDIS.observe(DataEventType.value) { (data) in
                var dict = data.value as? Dictionary<String, AnyObject>
            self.password = dict?["password"] as? String
            self.port = dict?["port"] as? Int
            self.url = dict?["url"] as? String
            
            self.redisManager = RedisClient(delegate: self)
            self.redisManager?.connect(host: self.url!, port: self.port!, pwd: self.password!)
            self.redisManager.exec(command: "PING") { (array) in
                print("Working---------")
                print("Array: \(array[0])")
            }
            completion()
            }
        
    }
    
    func setStatement(arr: [String], completion: @escaping ([String])->()){
        isConnected {
            var returnArray = [String]()
            self.redisManager.exec(args: arr) { (returnCode: NSArray!) in
                if returnCode.count > 0 {
                    returnArray.append("\(returnCode[0])")
                }
                completion(returnArray)
            }
        }
    }
    
    //
    //DISPLAYING ALERTSECTIONS/SITES
    //
    
    //RETURNING SECTIONS OF SITES WITH UPDATES
    func getFullSections(sections: [String], completion: @escaping ([String])->()){
        var getAlerts = "SMEMBERS Alert_Sections"
        var returnArray = [String]()
        for index in 0..<sections.count{
            self.redisManager?.exec(command: "SMEMBERS Alert_Sections/\(sections[index])", completion: { (array) in
                if array.count>0{
                    returnArray.append(sections[index])
                    print("Adding section: \(sections)")
                }
                completion(returnArray)
            })
        }
        
    }
    
    
    //RETURNING NAME OF SECTIONS
    func getAlertSites(siteSection: String, completion: @escaping ([String])->()){
        var getAlerts = "SMEMBERS Alert_Sections/\(siteSection)"
        var returnArray = [String]()
        self.redisManager.exec(command: getAlerts) { (array) in
            for index in 0..<array.count{
                
                returnArray.append(String(describing: array[index]))
            }
            completion(returnArray)
        }
    }
    
    func addAlertSite(siteSection: String, site: String,completion: @escaping(Bool)->()){
        self.redisManager?.exec(command: "SADD Alert_Sections/\(siteSection) \(site)", completion: { (array) in
            let returnCode = String(describing: array[0])
            print("Return code: \(returnCode)")
            completion(true)
        })
    }
    
    func removeAlertSites(siteSection: String, site: String ,completion: @escaping (Bool)->()){
        var string = "SREM Alert_Sections/\(siteSection) \(site)"
        print("This is string \(string)")
        self.redisManager?.exec(command: "SREM Alert_Sections/\(siteSection) \(site)", completion: { (array) in
            let returnCode = String(describing: array[0])
            print("Return code: \(returnCode)")
            if returnCode == "OK" {
                completion(true)
            } else {
                completion(true)
            }
        })
    }
    
    ////
    ////
    
    func getArrayStatement(sections: String, completion: @escaping ([String])->()){
        isConnected {
                var returnArray = [String]()
                self.redisManager?.exec(command: sections, completion: { (array: NSArray!) in
                    for index in 0..<array.count{
                        returnArray.append("\(array[index])")
                    }
                    print("Done")
                    completion(returnArray)
                })
        }
    }
    
    func clearSite(numString: String, completion: @escaping (Bool)->()){
        isConnected {
           self.redisManager?.exec(command: "HMSET site:\(numString) Cleaned TRUE Wood FALSE Duration NONE Description NONE", completion: { (array) in
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
        isConnected {
           self.redisManager?.exec(command: site, completion: { (array) in
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
    
    func isConnected(completion: @escaping ()->()){
        if redisManager.isConnected()==false{
            print("Have to reconnect")
                connectRedis {
                    print("reconnected redis")
                    completion()
                }
        }else{
            print("Already connected")
            completion()
        }
    }
}
    
    

