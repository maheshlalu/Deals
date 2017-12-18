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
        self.setUpBackButton()
        self.title = "Redeem"
        self.getApproveList()
//DealRedeems
//        if let reviewsArray = dealDetailDict.value(forKey: "DealRedeems") as? NSArray , reviewsArray.count != 0{
//            approveList = reviewsArray
//        }
        // Do any additional setup after loading the view.
        

    }
    
    func getApproveList(){
        /*
         http://api.walk2deals.com/api/Deal/ApproveDeals
         {
         "CurrentDate":"2017-12-12",
         "UserId":6,
         "PageSize":10,
         "PageNumber":1
         }
         */
        
        let parameters = ["CurrentDate":CXAppConfig.sharedInstance.dateToString(date: Date(), isDisplay: true),
                          "UserId":CXAppConfig.sharedInstance.getUserID(),"PageNumber":"\("1")","PageSize":"100"] //PageNumber
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
        CXLog.print(parameters)
        CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+"api/Deal/ApproveDeals", parameters: parameters as! [String : String]) { (responceDic) in
            CXLog.print("responce dict \(responceDic)")
            
            let error =  responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
                if let deals =  responceDic.value(forKey: "Deals") as? NSArray{
                    if deals.count == 0{
                        return
                    }
                    self.approveList = deals
                    self.approveTbl.reloadData()
                }
            }
            CXDataService.sharedInstance.hideLoader()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpBackButton(){
        let menuItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(SettingsViewController.backAction(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
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

        
        if let imageUrl = dataDict?.value(forKey: "ProfileImagePath") as? String ,!imageUrl.isEmpty {
            let img_Url1 = NSURL(string: imageUrl )
            approveCell?.userImgView.setImageWith(img_Url1 as URL!, usingActivityIndicatorStyle: .white)
            
        }
        //DealImageUrl
        //OfferTitle
        if  let offerTitle = dataDict?.value(forKey: "UserName") as? String{
            approveCell?.userNameLbl.text = offerTitle
        }
        if  let couponCode = dataDict?.value(forKey: "RedeemCode") as? String{
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
                CXDataService.sharedInstance.showAlert(message: "Approved Sucessfully", viewController: self)
                self.getApproveList()
            })
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123
    }
}

