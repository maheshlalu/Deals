//
//  CreateAccountViewController.swift
//  realTimeProject
//
//  Created by veerabrahmam suthari on 17/9/17.
//  Copyright © 2017 veerabrahmam suthari. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var createImage: UIImageView!

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

    @IBAction func createBtn(_ sender: UIButton) {
    }
  
}
