//
//  LoginViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 03/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var enterEmailTxt: UITextField!

    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func sendPasswordToEmail(emailStr:String){
        
       // CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
        
        let parameters = ["EmailAddress":emailStr]
        
        CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getforgotPasswordUrl(), parameters: parameters as! [String : String]) { (responceDic) in
            CXLog.print("responce dict \(responceDic)")
            
            CXDataService.sharedInstance.hideLoader()
            let error =  responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.setUpSidePanl()
                
            }else{
                CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
            }
            
        }

        
    }

    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Email?", message: "Please input your email:", preferredStyle: .alert)
        
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
            textField.placeholder = "Enter Email"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func loginBtnAction(_ sender: UIButton) {
        
        //UserName
        //Password
        
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")

        let parameters = ["UserName":self.enterEmailTxt.text,"Password":self.passwordTxt.text]
        
        CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getLoginUrl(), parameters: parameters as! [String : String]) { (responceDic) in
            CXLog.print("responce dict \(responceDic)")
            
            CXDataService.sharedInstance.hideLoader()
            let error =  responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.setUpSidePanl()
                
            }else{
                CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
            }
            
        }

        
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
