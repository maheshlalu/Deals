//
//  CXDataSaveManager.swift
//  Lefoodie
//
//  Created by apple on 15/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

private var savedManager:CXDataSaveManager! = CXDataSaveManager()

class CXDataSaveManager: NSObject  {
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    class var sharedInstance : CXDataSaveManager {
        return savedManager
    }
    
    func saveTheUserDetailsInDB(userDataDic:JSON){
        // LFMyProfile
        let relamInstance = try! Realm()
        // Query Realm for userProfile contains name
        let userData = relamInstance.objects(UserProfile.self).filter("userId=='\(userDataDic["UserId"].stringValue)'")
        if userData.count == 0 {
            //Insert The Data
            try! relamInstance.write({
                let profile  = UserProfile()
                profile.userId = userDataDic["UserId"].stringValue
                CXAppConfig.sharedInstance.saveUserID(userID: profile.userId)
                profile.email = userDataDic["EmailAddress"].stringValue
                profile.firstName = userDataDic["FirstName"].stringValue
                profile.gender = userDataDic["Gender"].stringValue
                profile.lastName = userDataDic["LastName"].stringValue
                profile.mobile = userDataDic["MobileNumber"].stringValue
                profile.image = userDataDic["ProfileImagePath"].stringValue
                profile.aDharNumbers = userDataDic["AdharNumber"].stringValue
                
                if let profilePath = userDataDic["ProfileImagePath"].dictionary {
                    if let image = profilePath["CDNFilePath"]?.string{
                        profile.image = image

                    }
                }
                
                relamInstance.add(profile)
            })
        }else{
            try! relamInstance.write({
            let profile = userData.first
            profile?.userId = userDataDic["UserId"].stringValue
            profile?.email = userDataDic["EmailAddress"].stringValue
            profile?.firstName = userDataDic["FirstName"].stringValue
            profile?.gender = userDataDic["Gender"].stringValue
            profile?.lastName = userDataDic["LastName"].stringValue
            profile?.mobile = userDataDic["MobileNumber"].stringValue
            profile?.image = userDataDic["ProfileImagePath"].stringValue
            profile?.aDharNumbers = userDataDic["AdharNumber"].stringValue
                if let profilePath = userDataDic["ProfileImagePath"].dictionary {
                    profile?.image = (profilePath["CDNFilePath"]?.string)!
                }
                
            })

        }
        
        /*
         ProfileImagePath =     {
         CDNFilePath = "http://89c864a87c3ad18dae47-7bbeedb9edb88b42dee08f7ffab566a2.r82.cf5.rackcdn.com//W2D/Dev/User/10027.jpg";
         FileContent = "<null>";
         FileName = "<null>";
         };
         */
        
    }
    
    func getTheUserProfileFromDB() -> UserProfile{
        let realm = try! Realm()
        let profile = realm.objects(UserProfile.self).first
        return profile!
        
    }
    
    func isSavedFavourites(postId:String)->Bool{
        let relamInstance = try! Realm()
        let favData = relamInstance.objects(Favourites.self).filter("postID=='\(postId)'")
        if favData.count == 0 {
            //Insert The Data
            try! relamInstance.write({
                relamInstance.add(favData)
            })
            return false
        }
        return true
    }
    
    /*
     CreatedById = 0;
     CreatedByName = "<null>";
     CreatedDate = "2017-09-26T18:33:16";
     DeviceId = 1;
     EmailAddress = "t@gmail.com";
     Errors =     (
     {
     ErrorCode = 0;
     ErrorText = "No errors found";
     }
     );
     FileContentCoreEntityList = "<null>";
     FirstName = "<null>";
     Gender = "<null>";
     Id = 5;
     IsActive = 1;
     IsVerified = 0;
     LastName = "<null>";
     MiddleName = "<null>";
     MobileNumber = 8096380038;
     ModifiedById = 0;
     ModifiedByName = "<null>";
     ModifiedDate = "<null>";
     Password = 486025;
     ProfileImagePath = "<null>";
     Role = 0;
     SubscribeNewsletter = 0;
     TotalPoints = 0;
     UserId = 5;
     */
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
       // let yourDate: Date? = formatter.date(from: myString)

        return dateFormatter.string(from: self)
    }
    
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
    
}
