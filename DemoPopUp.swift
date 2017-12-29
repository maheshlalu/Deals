//
//  DemoPopUp.swift
//  AAPopUp
//
//  Created by Muhammad Ahsan on 03/01/2017.
//  Copyright © 2017 AA-Creations. All rights reserved.
//

import UIKit
import AAPopUp

class DemoPopUp: UIViewController {
    
    @IBOutlet weak var demoLabel: UILabel!
    @IBOutlet weak var demoTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.demoTextView.layer.cornerRadius = 8.0
        self.demoTextView.layer.borderColor = UIColor.gray.cgColor
        self.demoTextView.layer.borderWidth = 2.0
        
       
        setBorder(demoTextView)
        
        
    }
    
    
    func setBorder(_ view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func demoButtonAction(_ sender: Any) {
        /*
         http://api.walk2deals.com/api/User/Feedback
         
         params Feedback="
         
         UserId=""
         */
        
        if self.demoTextView.text.count != 0 {
            let parameters = ["Feedback":self.demoTextView.text!,"UserId":CXDataSaveManager.sharedInstance.getTheUserProfileFromDB().userId]
            CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl() + "api/User/Feedback", parameters: parameters, completion: { (responce) in
                CXLog.print("feedback Responce \(responce)")
                self.dismiss(animated: true, completion: nil)

            })
            
        }else{
            
        }
        
        /*
         let alert = UIAlertView(title: "Alert", message: "Thanks for submitting your feedback!", delegate: nil, cancelButtonTitle: "OK")
         alert.performSelector(onMainThread: #selector(alert.show), with: nil, waitUntilDone: false)
         */
       
    }
 
    @IBAction func closeAction(_ sender: Any) {
        
        // MARK:- Dismiss action
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}



