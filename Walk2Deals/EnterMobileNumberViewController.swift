//
//  EnterMobileNumberViewController.swift
//  realTimeProject
//
//  Created by veerabrahmam suthari on 17/9/17.
//  Copyright © 2017 veerabrahmam suthari. All rights reserved.
//

import UIKit

class EnterMobileNumberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterNumberImage: UIImageView!
    @IBOutlet weak var enterNumberTxt: UITextField!
    @IBOutlet var lineView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        enterNumberImage.image = UIImage(named: "enter-mobile-no")
    
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberNextBtn(_ sender: UIButton) {
        
        if CXDataService.sharedInstance.validatePhoneNuber(value: self.enterNumberTxt.text!) {
            
            //            let url = "http://api.walk2deals.com/api/User/VerifyMobileNumber/8096380038"
            
            CXDataService.sharedInstance.showLoader(view: self.view, message: "OTP Sending...")

            let otpUrlString = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getOtpUrl() + "\(self.enterNumberTxt.text!)"

            CXDataService.sharedInstance.getTheDataFromServer(urlString: otpUrlString, completion: { (responceDic) in
                
                CXLog.print(responceDic)
                let responceDic = responceDic
                
                //Errors
                let error = responceDic.value(forKey: "Errors") as? NSArray
                let errorDict = error?.lastObject as? NSDictionary
                let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
                if errorcode == "0"{
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                   // CXLog.print(CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: responceDic, sourceKey: "Password"))
                    
                    /*
                     If password is null screen navigate to otp verification 
                     
                     */
                    
                    if let password = responceDic.value(forKey: "Password") as? String{
                        //}
                        //if !CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: responceDic, sourceKey: "Password").isEmpty{
                        let loginVc : LoginViewController = (storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
                        self.navigationController?.pushViewController(loginVc, animated: true)
                        
                    }else{
                        let verification : VerificationCodeViewController = (storyboard.instantiateViewController(withIdentifier: "Verification") as? VerificationCodeViewController)!
                        
                        verification.otpNumber = CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: responceDic, sourceKey: "OTP")
                        if let number = self.enterNumberTxt.text{
                            verification.mobileNumber = number
                        }
                        //verification.mobileNumber = CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: errorDict!, sourceKey: "MobileNumber")
                        
                        /*
                         "MobileNumber": "8096380038",
                         "OTP": "597143",
                         */
                        // verification.mobileNumber = self.enterNumberTxt.text
                        self.navigationController?.pushViewController(verification, animated: true)
                    }
                }
                CXDataService.sharedInstance.hideLoader()

            })
            
            /*
             {
             "Id": 10,
             "MobileNumber": "8096380038",
             "OTP": "597143",
             "MessageText": "W2D Login OTP:597143",
             "Password": null,
             "UserId": 0,
             "ErrorCode": null,
             "ErrorMessage": null,
             "MessageId": null,
             "CreatedById": 0,
             "CreatedByName": null,
             "CreatedDate": "0001-01-01T00:00:00",
             "ModifiedById": 0,
             "ModifiedByName": null,
             "ModifiedDate": null,
             "IsActive": false,
             "Errors": [
             {
             "ErrorCode": "0",
             "ErrorText": "No errors found"
             }
             ]
             }
             */
            
            
            
       
        }else{
            CXDataService.sharedInstance.showAlert(message: "Please Enter Valid Phone Number", viewController: self)
        }
    }
    

}
