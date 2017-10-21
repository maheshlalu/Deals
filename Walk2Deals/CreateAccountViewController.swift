//
//  CreateAccountViewController.swift
//  realTimeProject
//
//  Created by veerabrahmam suthari on 17/9/17.
//  Copyright © 2017 veerabrahmam suthari. All rights reserved.
//

import UIKit
import SwiftyJSON
class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var createImage: UIImageView!
    var phoneNumber :String!

    @IBOutlet weak var createLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        createImage.image = UIImage(named:"logo")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
     "{""FirstName"":""Jyoshna"",""LastName"":""Madhuri',""EmailAddress"":""jyoshnasaimadhuri@gmail.com"",""MobileNumber"":""7989298353"",
     ""Password"":""1234"",
     ""DeviceId"":""1""}
    
     "
     */
    @IBAction func createBtn(_ sender: UIButton) {
        
        if self.emailTxt.text?.characters.count == 0 || !CXDataService.sharedInstance.isValidEmail(testStr: self.emailTxt.text!){
            CXDataService.sharedInstance.showAlert(message: "Please Enter Valid Email", viewController: self)
        }else if self.passwordTxt.text?.characters.count == 0 {
            CXDataService.sharedInstance.showAlert(message: "Please Enter Valid Password", viewController: self)

        }else if self.confirmPasswordTxt.text?.characters.count == 0 {
            CXDataService.sharedInstance.showAlert(message: "Please Enter Valid Confirm Password", viewController: self)

        }else if self.passwordTxt.text != self.confirmPasswordTxt.text{
            CXDataService.sharedInstance.showAlert(message: "Password and Confirm Password Not matched", viewController: self)

        }else{
            CXDataService.sharedInstance.showLoader(view: self.view, message: "Creating Account...")
            if let email = self.emailTxt.text ,let password = self.passwordTxt.text {
            let parameters = ["EmailAddress":email,"MobileNumber":self.phoneNumber,"Password":password,"DeviceId":"1"]
                
            CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getRegisterUrl(), parameters: parameters as! [String : String]) { (responceDic) in
                CXLog.print("responce dict \(responceDic)")
                
                let error = responceDic.value(forKey: "Errors") as? NSArray
                let errorDict = error?.lastObject as? NSDictionary
                let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
                if errorcode == "0"{
                    CXDataSaveManager.sharedInstance.saveTheUserDetailsInDB(userDataDic: JSON(responceDic))
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.setUpSidePanl()
                }else{
                    CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
                }
             
            }

        }
        }

    }
  
}
