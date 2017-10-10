//
//  DealsDetailsViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 05/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class DealsDetailsViewController: UIViewController {

    var dealId :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDealDataByID()
        
        CXLog.print(dealId)

        // Do any additional setup after loading the view.
    }

    
    func getDealDataByID(){
       // http://api.walk2deals.com/api/Deal/GetById/2
        let otpUrlString = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getDealByIDUrl() + "\(self.dealId!)"
        CXDataService.sharedInstance.getTheDataFromServer(urlString: otpUrlString, completion: { (responceDic) in
            CXLog.print(" deail deatil dic\(responceDic)")
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
