//
//  VerificationCodeViewController.swift
//  realTimeProject
//
//  Created by veerabrahmam suthari on 17/9/17.
//  Copyright © 2017 veerabrahmam suthari. All rights reserved.
//

import UIKit

class VerificationCodeViewController: UIViewController, UITextFieldDelegate {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       /* tf1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)*/

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tf1.becomeFirstResponder()
    }
   
    @IBAction func verificationBtn(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let create : CreateAccountViewController = (storyboard.instantiateViewController(withIdentifier: "Create") as? CreateAccountViewController)!
        self.navigationController?.pushViewController(create, animated: true)
    }
}
