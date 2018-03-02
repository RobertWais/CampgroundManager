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
    
    
    func connectRedis(){
        redisManager = RedisClient(delegate: self)
        redisManager?.connect(host:"Localhost",
                                          port: 6379,
                                          pwd: "password")
        print("Hre")
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
    
    
    func statementRedis(){
       
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
