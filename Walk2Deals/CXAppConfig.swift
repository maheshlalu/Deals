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
    func saveReviewUrl() -> String {
        return config!.value(forKey: "reviewSave") as! String
    }
    
    //getUserData
    
    func getUserDataUrl() -> String{
        return config!.value(forKey: "getUserData") as! String
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
    
    //getAllLocations
    func getAllLocations() -> String{
        return config!.value(forKey: "getAllLocations") as! String

    }
    
    //saveReedm
    func getSaveReedm() -> String{
        return config!.value(forKey: "saveReedm") as! String
        
    }
    //ApproveRedeem
    func getApproveRedeem() -> String{
        return config!.value(forKey: "ApproveRedeem") as! String
        
    }
    
    static func resultString(_ input: AnyObject) -> String{
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
    //reviewSave
    
    
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



    func dateToString(date:Date,isDisplay:Bool) -> String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        if isDisplay {
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            
        }else{
            formatter.dateFormat = "yyyy-MM-dd"
        }
        // again convert your date to string
        return formatter.string(from: yourDate!)
    }
    
    func stringToDate(dateString:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"/* date_format_you_want_in_string from
         * http://userguide.icu-project.org/formatparse/datetime
         */
        let date = dateFormatter.date(from: dateString)
        //2017-10-26T00:00:00
        //let isoDate = "2016-04-14T10:44:00+0000"
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"/* date_format_you_want_in_string from*/
        return dateFormatter.string(from: date!)

    }
    
    func appColor() -> UIColor{
       
        return UIColor(red: 8/255, green: 128/255, blue: 124/255, alpha: 1.0)
    }
    
}


