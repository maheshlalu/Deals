//
//  LoginViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 03/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import SwiftyJSON
class LoginViewController: UIViewController {
   // @IBOutlet weak var enterEmailTxt: UITextField!

    @IBOutlet weak var passwordTxt: UITextField!
    var email : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func sendPasswordToEmail(emailStr:String){
        
       // CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
        
        
        var parameter = ["":""]
        if CXDataService.sharedInstance.isValidEmail(testStr: emailStr) {
             parameter = ["EmailAddress":emailStr]

        } else if CXDataService.sharedInstance.validatePhoneNuber(value: emailStr){
            parameter = ["MobileNumber":emailStr]

        }else{
            CXDataService.sharedInstance.showAlert(message: "Please Enter Valid Input", viewController: self)
            return
        }

        CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getforgotPasswordUrl(), parameters: parameter as! [String : String]) { (responceDic) in
            CXLog.print("responce dict \(responceDic)")
            
            CXDataService.sharedInstance.hideLoader()
            let error =  responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
                //let appDelegate = UIApplication.shared.delegate as? AppDelegate
               // appDelegate?.setUpSi
                self.view.makeToast(message: "Password Set to your mobile/email")
                
                
            }else{
                let ErrorText = errorDict?.value(forKey: "ErrorText") as? String
                CXDataService.sharedInstance.showAlert(message: ErrorText!, viewController: self)
            }
        }

    }

    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Walk2Deals", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                self.sendPasswordToEmail(emailStr: field.text!)
                // store your data
                //UserDefaults.standard.set(field.text, forKey: "userEmail")
                //UserDefaults.standard.synchronize()
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter email/Phone Number"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func loginBtnAction(_ sender: UIButton) {
        
        //UserName
        //Password
        //SelectLocationViewController
        //SelectLocationViewController
        if let email = self.passwordTxt.text, !email.isEmpty{
            CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
            let parameters = ["UserName":self.email,"Password":self.passwordTxt.text]
            CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getLoginUrl(), parameters: parameters as! [String : String]) { (responceDic) in
                CXLog.print("responce dict \(responceDic)")
                CXDataService.sharedInstance.hideLoader()
                let error =  responceDic.value(forKey: "Errors") as? NSArray
                let errorDict = error?.lastObject as? NSDictionary
                let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
                if errorcode == "0"{
                    //CXAppConfig.sharedInstance.saveUserID(userID: "")
                    CXDataSaveManager.sharedInstance.saveTheUserDetailsInDB(userDataDic: JSON(responceDic))
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.setUpSidePanl()
                  //  self.loadLocationView()
                }else{
                    CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
                }
            }
        }else{
            CXDataService.sharedInstance.showAlert(message: "Please Enter Inputs", viewController: self)
        }
    }
    
    func loadLocationView(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let locationView = storyBoard.instantiateViewController(withIdentifier: "SelectLocationViewController") as! SelectLocationViewController
        self.navigationController?.pushViewController(locationView, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
