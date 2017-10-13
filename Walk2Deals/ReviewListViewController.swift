//
//  ReviewListViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 05/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class ReviewListViewController: UIViewController {
    var dealDetailDict : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getReviews()

        // Do any additional setup after loading the view.
    }
    
    func getReviews(){
        
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
        
        let otpUrlString = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getByReviewUrl() + "\("")"
        
        CXDataService.sharedInstance.getTheDataFromServer(urlString: otpUrlString, completion: { (responceDic) in
            
            CXLog.print(responceDic)
            let responceDic = responceDic
            
            //Errors
            let error = responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
         
                }
            
            CXDataService.sharedInstance.hideLoader()
            
        })
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
