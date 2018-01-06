//
//  ChangePasswordVc.swift
//  Walk2Deals
//
//  Created by Rama on 1/5/18.
//  Copyright © 2018 ongo. All rights reserved.
//

import UIKit

class ChangePasswordVc: UIViewController {
    
   
    @IBOutlet var oldPwdTxt: ACFloatingTextfield!
    @IBOutlet var newPwdTxt: ACFloatingTextfield!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBackButton()
        self.title = "Change Password"

        // Do any additional setup after loading the view.
    }
    @IBAction func chnagePwdAction(_ sender: UIButton) {
        
        let oldSavePwd = CXAppConfig.sharedInstance.getPassword()
        if let oldTxt = self.oldPwdTxt.text,let newPwd = self.newPwdTxt.text , oldTxt.count != 0 ,newPwd.count != 0{
            if oldTxt == oldSavePwd {
                let changePwdUrl = CXAppConfig.sharedInstance.getBaseUrl() + "api/User/Save"
                let id = CXDataSaveManager.sharedInstance.getTheUserProfileFromDB().userId
                let parameters = ["Id":id,"UserId":id,"Password":newPwd]
                CXDataService.sharedInstance.postTheDataToServer(urlString: changePwdUrl, parameters: parameters, completion: { (responce) in
                    CXLog.print(responce)
                    CXDataService.sharedInstance.showAlert(message: "Password Successfully Changed", viewController: self)
                })
                
            }else{
                self.view.makeToast(message: "You enter old password wrog!!!")
            }
        }else{
            self.view.makeToast(message: "Please Enter Inputs")
        }
        /*
         http://api.walk2deals.com/api/User/Save
         jsonObject.put("Id", userId);
         jsonObject.put("UserId", userId);
         jsonObject.put("Password", password);
         
         */
    }
    func setUpBackButton(){
        let menuItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(ChangePasswordVc.backAction(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            
           
        }
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
