//
//  CXAppConfig.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/22/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation

class CXAppConfig {
    /// the singleton
    static let sharedInstance = CXAppConfig()
    
    // This prevents others from using the default '()' initializer for this class.
    fileprivate init() {
        loadConfig()
    }
    
    /// the config dictionary
    var config: NSDictionary?
    
    /**
     Load config from Config.plist
     */
    func loadConfig() {
        if let path = Bundle.main.path(forResource: "Configuration", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)
            
        }
    }
    

    
    /**
     Get base url from Config.plist
     
     - Returns: the base url string from Config.plist
     */
    func getBaseUrl() -> String {
        return config!.value(forKey: "BaseUrl") as! String
    }
    
    func getRegisterUrl() -> String {
        return config!.value(forKey: "register") as! String
    }
    
    
    func getTheDataInDictionaryFromKey(sourceDic:NSDictionary,sourceKey:NSString) ->String{
        let keyExists = sourceDic[sourceKey] != nil
        if keyExists {
            // now val is not nil and the Optional has been unwrapped, so use it
            return sourceDic[sourceKey]! as! String
        }
        return ""
        
    }
    
    func setDeviceToken(deviceToken:String){
        
        UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
        
    }
    
    func getDeviceToken() -> String{
        if(UserDefaults.standard.object(forKey: "deviceToken") == nil){
            return ""
        }else{
            return UserDefaults.standard.value(forKey: "deviceToken") as! String
        }
    }
    
    static func resultString(input: AnyObject) -> String{
        if let value: AnyObject = input {
            var reqType : String!
            switch value {
            case let i as NSNumber:
                reqType = "\(i)"
            case let s as NSString:
                reqType = "\(s)"
            case let a as NSArray:
                reqType = "\(a.object(at: 0))"
            default:
                reqType = "Invalid Format"
            }
            return reqType
        }
        return ""
    }

    
}
