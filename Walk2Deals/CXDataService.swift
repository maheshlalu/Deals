//
//  CXDataService.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/24/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
private var _SingletonSharedInstance:CXDataService! = CXDataService()

open class CXDataService: NSObject {
    var progress : MBProgressHUD!

    class var sharedInstance : CXDataService {
        return _SingletonSharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    class Connectivity {
        class func isConnectedToInternet() ->Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
   
    
    func constructHttpHeader() -> HTTPHeaders{
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let user = "ae632c7fb300455c8e72fe0ae05ef283"
        let password = "F15E9DA4E0EDAEC"
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        return headers
    }
    
    open func getTheDataFromServer(urlString:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        if Bool(1) {
            if !Connectivity.isConnectedToInternet() {
                CXLog.print("Yes! internet is Not available.")
                self.showAlertView(status: 0)
                return
            }
            
            Alamofire.request(urlString, headers:self.constructHttpHeader()).responseJSON{ response in
                CXLog.print(response)
                switch response.result {
                case .success:
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    //completion((response.result.value as? NSDictionary)!)
                    completion(JSON)
                    break
                }
                CXLog.print(response)
                // Do stuff
                case .failure(let error):
                    print(error)
                }}
        
    }
    
    }
    
    open func postTheDataToServer(urlString:String,parameters:[String : String],completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.constructHttpHeader()).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    //completion((response.result.value as? NSDictionary)!)
                    completion(JSON)
                    break
                }
                CXLog.print(response)
                break
            default :
                break
            }
        }

        
    }
    open func getTheAppDataFromServer(_ parameters:[String: AnyObject]? = nil ,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        if Bool(1) {
            if !Connectivity.isConnectedToInternet() {
                CXLog.print("Yes! internet is available.")
                self.showAlertView(status: 0)
                return
                // do some tasks..
            }
     
            let url = "http://api.walk2deals.com/api/User/VerifyMobileNumber/8096380038"
            Alamofire.request(url, headers:self.constructHttpHeader()).responseJSON{ response in
                CXLog.print(response)
                switch response.result {
                case .success: break
                    CXLog.print(response)
                // Do stuff
                case .failure(let error):
                    print(error)
                }}
            
            let headers: HTTPHeaders = [
                "Authorization": "key=AIzaSyDL0UKlnPC5s8hvAB65qOvEXYzp0jwxXoM",
                "Accept": "application/json"
            ]
            /*
             title = App Name
             body = message
             "message": "tesing from postman",
             "notification":{"message":"tesing from postman","title":"lefoodie noty IOS",    "body" : "This week's edition is now available.",
             }}
             */
            //"message": CXAppConfig.sharedInstance.convertDictionayToString(dictionary: notificationMesDic),
            let parameters : [String : NSString] = ["":""]
            ///["to","notification"]
            Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.constructHttpHeader()).responseJSON { response in
                switch response.result {
                case .success: break
                default :
                    break
                }
            }
            
         /*   Alamofire.request("", method: .post, parameters: parameters, encoding: URLEncoding.`default`)
                .responseJSON { response in
                    //to get status code
                    switch (response.result) {
                    case .success:
                        //to get JSON return value
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            //completion((response.result.value as? NSDictionary)!)
                            completion(JSON)
                        }
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCancelled{
                            //timeout here
                            self.showAlertView(status: 0)
                        }
                        break
                    }
            }*/
        }
    }
    
    func generateBoundaryString() -> String
    {
        return "\(UUID().uuidString)"
    }
    
    open func synchDataToServerAndServerToMoblile(_ urlstring:String, parameters:[String: AnyObject]? = nil ,completion:@escaping (_ responseDict:NSDictionary) -> Void){
    
        if !Connectivity.isConnectedToInternet() {
            CXLog.print("Yes! internet is available.")
            self.showAlertView(status: 0)
            return
            // do some tasks..
        }
       /* Alamofire.request(.POST,urlstring, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(responseDict: (response.result.value as? NSDictionary)!)
                    break
                case .failure(let error):
                }
        }*/
        Alamofire.request(urlstring, method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
                switch (response.result) {
                case .success:
                    //to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        //completion((response.result.value as? NSDictionary)!)
                        completion(JSON)
                    }
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        //timeout here
                        self.showAlertView(status: 0)

                    }
                    break
                }
        }
    }
    
    
    func convertStringToDictionary(_ string:String) -> NSDictionary {
        var jsonDict : NSDictionary = NSDictionary()
        let data = string.data(using: String.Encoding.utf8)
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary            // CXDBSettings.sharedInstance.saveAllMallsInDB((jsonData.valueForKey("orgs") as? NSArray)!)
        } catch {
        }
        return jsonDict
    }

    
    func showAlertView(status:Int) {
        self.hideLoader()
        let alert = UIAlertController(title:"Network Error!!!", message:"Please bear with us.Thank You!!!", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            if status == 1 {
                
            }else{
                
            }
        }
        alert.addAction(okAction)
        //self.present(alert, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showLoader(view:UIView,message:String){
     
        self.progress = MBProgressHUD.showAdded(to: view, animated: true)
        self.progress.mode = MBProgressHUDMode.indeterminate
        self.progress.labelText = message
        self.progress.show(animated: true)

    }
    
    func hideLoader(){
      //  LoadingView.hide()
        if let progress = self.progress {
            progress.hide(animated: true)
        }
    }

    
    open func getTheUpdatesFromServer(_ parameters:[String: AnyObject]? = nil ,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        if !Connectivity.isConnectedToInternet() {
            CXLog.print("Yes! internet is available.")
            self.showAlertView(status: 0)
            return
            // do some tasks..
        }
        
       /* https://api.withfloats.com/Discover/v2/floatingPoint/bizFloats?clientId=5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6&skipBy=0&fpid=kljadlkcjasd898979
         
         clientId=5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6&skipBy=0&fpid=kljadlkcjasd898979
        */
       /* Alamofire.request(.GET,"https://api.withfloats.com/Discover/v2/floatingPoint/bizFloats?", parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(responseDict: (response.result.value as? NSDictionary)!)
                    break
                case .failure(let error):
                }
        }
        */
   
        Alamofire.request("https://api.withfloats.com/Discover/v2/floatingPoint/bizFloats?", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
                switch (response.result) {
                case .success:
                    //to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        //completion((response.result.value as? NSDictionary)!)
                        completion(JSON)
                    }
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        //timeout here
                    }
                    break
                }
        }
    }
    
    func showAlert(message:String,viewController:UIViewController)
    {
        let alert = UIAlertController.init(title: "WalkDeals", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (okAction) in
            
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func updateTheProfileAndAddThePostAdd(mainDict:NSMutableDictionary,jsonKeyName:String,imageData:Data,imageKey:String,urlString:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imageData, withName: imageKey,fileName: "file.jpg", mimeType: "image/jpg")
            
            multipartFormData.append(self.constructTheJson(ticketsInput: mainDict).data(using: String.Encoding.utf8)!, withName: jsonKeyName )
        },
                         to:urlString,
                         method:.post,
                         headers:self.constructHttpHeader())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)
                    print(response.result.value)
                    completion(response.result.value as! NSDictionary)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }
    
    func imageData(){
        
        let mainDict = NSMutableDictionary()
        mainDict["OfferTitle"] = "final  special offer"
        mainDict["OfferDescription"] = "reste87fghfgh9sdfsdfrt"
        mainDict["StartDate"] = "2017-9-17"
        mainDict["EndDate"] = "2017-9-28"
        mainDict["UserId"] = "18"
        let dict = ["CategoryId":"1"]
        
        /*
         DealCoreEntity =  {
         "OfferTitle": "test",
         "OfferDescription": "test",
         "StartDate": "2017-9-17",
         "EndDate": "2017-9-28",
         "UserId": 18,
         "DealCategories": [
         {
         "CategoryId": 1
         }
         ],
         "DealLocations": [
         {
         "StoreLocationId": 2,
         "isActive": true
         }
         ]
         }
         2= "file"
         api/Deal/Save*/
        let array = [dict]
        mainDict["DealCategories"] = array
        
        let subDict = NSMutableDictionary()
        subDict["StoreLocationId"] = "2"
        subDict["IsActive"] = "true"
        let arr = [subDict]
        mainDict["DealLocations"] = arr
        
        print(mainDict)
        //self.myImageUploadRequest(dataDic: mainDict)
        //return
        
        let image = UIImage(named: "sampleDeal")
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imgData, withName: "2",fileName: "file.jpg", mimeType: "image/jpg")
            
            multipartFormData.append(self.constructTheJson(ticketsInput: mainDict).data(using: String.Encoding.utf8)!, withName: "DealCoreEntity" )
        },
                         to:"http://api.walk2deals.com/api/Deal/Save",
                         method:.post,
                         headers:self.constructHttpHeader())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)
                    print(response.result.value)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    
    func constructTheJson(ticketsInput:NSMutableDictionary) -> String{
        
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: ticketsInput, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
        }
        let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
        
        return jsonStringFormat!
    }
    func getUserProfileData(){
        // http://api.walk2deals.com/api/User/GetById/18
        
        CXDataService.sharedInstance.getTheDataFromServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUserDataUrl() + CXDataSaveManager.sharedInstance.getTheUserProfileFromDB().userId, completion: { (responceDic) in
            CXLog.print(responceDic)
            let responceDic = responceDic
            //Errors
            let error = responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
                CXDataSaveManager.sharedInstance.saveTheUserDetailsInDB(userDataDic: JSON(responceDic))
            }
        })
        
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

//MARK: Validations
extension CXDataService{
    
   
    func validatePhoneNuber(value: String) -> Bool {
        let types:NSTextCheckingResult.CheckingType = [.phoneNumber]
        guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
        
        if let match = detector.matches(in: value, options: [], range: NSMakeRange(0, value.characters.count)).first?.phoneNumber {
            return match == value
        }else{
            return false
        }
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: testStr) {
            return true
        }
        return false

    }
    
    func faveButtonAction(inputDict:[String:String]){
        CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSaveFavouriteUrl(), parameters: inputDict) { (responceDic) in
            CXLog.print("responce dict \(responceDic)")
            let error =  responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
                //let deals =  responceDic.value(forKey: "Deals") as? NSArray
                // self.dealsArray = NSMutableArray(array: deals!)
            }else{
               // CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
            }
        }
    }
    
}
