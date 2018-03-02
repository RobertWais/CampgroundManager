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
    
    
    func statementRedis(){
        if(redisManager.isConnected()){
        redisManager?.exec(command: "HGETALL site:1", completion:
            { (array: NSArray!) in
                print("User is \(array[0])")
                // this is where the completion handler code goes
            })
        }else{
            print("NOT connected")
        }
    }
    
    func subscriptionMessageReceived(channel: String, message: String) {
        print("Yup")
    }
    
    func socketDidDisconnect(client: RedisClient, error: Error?) {
        print("Disconnecting")
    }
    
    func socketDidConnect(client: RedisClient) {
        
        print("Connected..")
    }
    
    
    
    
}
