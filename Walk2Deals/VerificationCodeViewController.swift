//
//  VerificationCodeViewController.swift
//  realTimeProject
//
//  Created by veerabrahmam suthari on 17/9/17.
//  Copyright © 2017 veerabrahmam suthari. All rights reserved.
//

import UIKit

class VerificationCodeViewController: UIViewController {
    let TEXT_FIELD_LIMIT = 1
    var mobileNumber : String!
    
    @IBOutlet weak var msgDisplayLbl: UILabel!
    
    @IBOutlet weak var otpText6: UITextField!
    
    @IBOutlet weak var otpText5: UITextField!
    @IBOutlet weak var otpText3: UITextField!
    @IBOutlet weak var otpText4: UITextField!
    @IBOutlet weak var otpText1: UITextField!
    @IBOutlet weak var otpText2: UITextField!
    
    var otpNumber : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.msgDisplayLbl.text =  "Please type the verification code sent to \(self.mobileNumber!)"
        otpText1.delegate = self
        otpText2.delegate = self
        otpText3.delegate = self
        otpText4.delegate = self
        otpText5.delegate = self
        otpText6.delegate = self
        otpText1.addTarget(self, action: #selector(VerificationCodeViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        otpText2.addTarget(self, action: #selector(VerificationCodeViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)

        otpText3.addTarget(self, action: #selector(VerificationCodeViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)

        otpText4.addTarget(self, action: #selector(VerificationCodeViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        otpText5.addTarget(self, action: #selector(VerificationCodeViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        otpText6.addTarget(self, action: #selector(VerificationCodeViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)

        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tf1.becomeFirstResponder()
    }
    
    @IBAction func verificationBtn(_ sender: UIButton) {
        
        let otpCode = self.otpText1.text! + self.otpText2.text! + self.otpText3.text! + self.otpText4.text! + self.otpText5.text! + self.otpText6.text!
        
        
        if otpCode == self.otpNumber {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let create : CreateAccountViewController = (storyboard.instantiateViewController(withIdentifier: "Create") as? CreateAccountViewController)!
            create.phoneNumber = self.mobileNumber
            self.navigationController?.pushViewController(create, animated: true)
        }else{
            
            CXDataService.sharedInstance.showAlert(message: "Please Enter Valid OTP", viewController: self)
        }
        
        
      /*  var number = self.otpText1.text + self.otpText2.text + self.otpText3.text + self.otpText4.text + self.otpText5.text + self.otpText6.text
        
        if number == self.mobi {
            <#code#>
        }*/
        
   
    }
}

extension VerificationCodeViewController: UITextFieldDelegate{
    
    func textFieldDidChange(_ textField: UITextField){
        textField.text = textField.text?.uppercased()
        
        let text = textField.text
        
        if text?.utf16.count==1{
            switch textField{
            case otpText1:
                otpText2.becomeFirstResponder()
                break
            case otpText2:
                otpText3.becomeFirstResponder()
                break
            case otpText3:
                otpText4.becomeFirstResponder()
                break
            case otpText4:
                otpText5.becomeFirstResponder()
                //self.view.endEditing(true)
                break
            case otpText5:
                otpText6.becomeFirstResponder()
                self.view.endEditing(true)
                break
            default:
                break
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        
    {
        return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= TEXT_FIELD_LIMIT
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

}
