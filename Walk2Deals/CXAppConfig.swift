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
    
    func getOtpUrl() -> String {
        return config!.value(forKey: "getOtpUlr") as! String
    }
    
    func getDealsUrl() -> String {
        return config!.value(forKey: "getDealsUlr") as! String
    }
    //getOtpUlr
    //saveFavourite
    
    func getSaveFavouriteUrl() -> String {
        return config!.value(forKey: "saveFavourite") as! String
    }
    
    //loginUrl
    
    func getLoginUrl() -> String {
        return config!.value(forKey: "loginUrl") as! String
    }
    
    //forgotPasswordUrl
    
    func getforgotPasswordUrl() -> String {
        return config!.value(forKey: "forgotPasswordUrl") as! String
    }
    
    //getDeailByID
    func getDealByIDUrl() -> String {
        return config!.value(forKey: "getDeailByID") as! String
    }
    
    //getReviews
    
    func getByReviewUrl() -> String {
        return config!.value(forKey: "getReviews") as! String
    }
    
    func getTheDataInDictionaryFromKey(sourceDic:NSDictionary,sourceKey:NSString) ->String{
        let keyExists = sourceDic[sourceKey] != nil
        if keyExists {
            // now val is not nil and the Optional has been unwrapped, so use it
            return sourceDic[sourceKey]! as! String
        }
        return ""
        
    }
    func getUserID() -> String{
        if(UserDefaults.standard.object(forKey: "USER_ID") == nil){
            return ""
        }else{
            return UserDefaults.standard.value(forKey: "USER_ID") as! String
        }
    }
    
    func saveUserID(userID:String){
        UserDefaults.standard.set(userID, forKey: "USER_ID")

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
