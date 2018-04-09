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
    
    func getAlertSections(completion: @escaping ([String])->()){
        var getAlerts = "SMEMBERS Alert_Sections"
        var returnArray = [String]()
        self.redisManager?.exec(command: getAlerts, completion: { (array) in
            let returnCode = String(describing: array[0])
            for index in 0..<array.count{
                returnArray.append(String(describing: array[index]))
            }
            completion(returnArray)
        })
    }
    
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
    
    

