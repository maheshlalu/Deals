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
    
}
