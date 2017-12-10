//
//  ApproveViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 09/12/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class ApproveViewController: UIViewController {

    @IBOutlet weak var approveTbl: UITableView!
    var dealDetailDict : NSDictionary!
    var approveList : NSArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
//DealRedeems
        if let reviewsArray = dealDetailDict.value(forKey: "DealRedeems") as? NSArray , reviewsArray.count != 0{
            approveList = reviewsArray
        }
        // Do any additional setup after loading the view.
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

extension ApproveViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.approveList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let approveCell = tableView.dequeueReusableCell(withIdentifier: "ApproveTableViewCell") as? ApproveTableViewCell
           // titleCell?.dealTitleLbl.text = dealDetailDict.value(forKey: "OfferTitle") as? String

        approveCell?.approveBtn.addTarget(self, action:#selector(approveAction(sender:)), for: .touchUpInside)
        approveCell?.approveBtn.tag = indexPath.row
        let dataDict = self.approveList[indexPath.row] as? NSDictionary

        
        if let imageUrl = dataDict?.value(forKey: "UserImage") as? String ,!imageUrl.isEmpty {
            let img_Url1 = NSURL(string: imageUrl )
            approveCell?.userImgView.setImageWith(img_Url1 as URL!, usingActivityIndicatorStyle: .white)
            
        }
        //DealImageUrl
        //OfferTitle
        if  let offerTitle = dataDict?.value(forKey: "UserName") as? String{
            approveCell?.userNameLbl.text = offerTitle
        }
        if  let couponCode = dataDict?.value(forKey: "CouponCode") as? String{
            approveCell?.couponCodeLbl.text = couponCode
        }
        /*
         CouponCode = W2DEAL011063011029;
         DealId = 10063;
         Id = 3;
         MobileNumber = 8096380038;
         UserId = 10029;
         UserImage = "http://89c864a87c3ad18dae47-7bbeedb9edb88b42dee08f7ffab566a2.r82.cf5.rackcdn.com//W2D/Dev/User/10033.jpg";
         */
        
            return approveCell!
    }
    
    func approveAction(sender:UIButton){
        /*
         POST api/Deal/ApproveRedeem
         
         Request 1
         {
         "CouponCode":"W2DEAL011132001001",
         "UserId":7
         }
         
         Request2
         {
         “Id”:1,
         "UserId":7
         
         CouponCode = W2DEAL011063011029;
         DealId = 10063;
         Id = 3;
         MobileNumber = 8096380038;
         UserId = 10029;
         UserImage = "http://89c864a87c3ad18dae47-7bbeedb9edb88b42dee08f7ffab566a2.r82.cf5.rackcdn.com//W2D/Dev/User/10033.jpg";
         }
         */
        
        let urlString = CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getApproveRedeem()
        let dataDict = self.approveList[sender.tag]
        if let dealID = (dataDict as AnyObject).value(forKey: "Id") as? Int{
            let parameters = ["Id":String(dealID),"UserId":CXAppConfig.sharedInstance.getUserID()]
            CXDataService.sharedInstance.postTheDataToServer(urlString: urlString, parameters: parameters, completion: { (responce) in
                CXLog.print(responce)
                
            })
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123
    }
}

