//
//  VerificationCodeViewController.swift
//  realTimeProject
//
//  Created by veerabrahmam suthari on 17/9/17.
//  Copyright © 2017 veerabrahmam suthari. All rights reserved.
//

import UIKit

class VerificationCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var verificationImage: UIImageView!
    
    @IBOutlet weak var verificationLbl: UILabel!
    
    @IBOutlet weak var verificationLbl1: UILabel!
    
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verificationImage.image = UIImage(named: "verification-code")
        
        tf1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tf1.becomeFirstResponder()
    }
    func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField {
            case tf1:
                tf2.becomeFirstResponder()
            case tf2:
                tf3.becomeFirstResponder()
            case tf3:
                tf4.becomeFirstResponder()
            case tf4:
                tf4.resignFirstResponder()
            default:
                break
            }
        }
    }
    @IBAction func verificationBtn(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let create : CreateAccountViewController = (storyboard.instantiateViewController(withIdentifier: "Create") as? CreateAccountViewController)!
        self.navigationController?.pushViewController(create, animated: true)
    }
}
