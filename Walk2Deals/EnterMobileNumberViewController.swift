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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberNextBtn(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let verification : VerificationCodeViewController = (storyboard.instantiateViewController(withIdentifier: "Verification") as? VerificationCodeViewController)!
        self.navigationController?.pushViewController(verification, animated: true)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }

}
