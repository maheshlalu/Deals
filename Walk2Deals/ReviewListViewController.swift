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
    var reviewsList : NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getReviews()
        
        //DealReviews
        
        reviewsList = dealDetailDict.value(forKey: "DealReviews") as! NSArray


        // Do any additional setup after loading the view.
    }
    
    func getReviews(){
        
       /* if let dealID = dealDetailDict?.value(forKey: "Id") as? Int{
            CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
            let otpUrlString = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getByReviewUrl() + "\(dealID)"
            CXDataService.sharedInstance.getTheDataFromServer(urlString: otpUrlString, completion: { (responceDic) in
                CXLog.print("revies dict \(responceDic)")
                //Errors
                let error = responceDic.value(forKey: "Errors") as? NSArray
                let errorDict = error?.lastObject as? NSDictionary
                let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
                if errorcode == "0"{
                    
                }
                CXDataService.sharedInstance.hideLoader()
            })
        }*/
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

extension ReviewListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let review : ReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as! ReviewTableViewCell
        let reviewDic = self.reviewsList[indexPath.row] as? NSDictionary
        
       // review.userImg.image =
        
        review.userNameLbl.text = reviewDic?.value(forKey: "UserName") as? String
        review.reviewTxtLbl.text = reviewDic?.value(forKey: "ReviewComments") as? String

        
        return review
        
        /*
         CreatedById = 0;
         CreatedByName = "<null>";
         CreatedDate = "0001-01-01T00:00:00";
         DealId = 0;
         DealName = "<null>";
         Errors = "<null>";
         Id = 0;
         IsActive = 0;
         ModifiedById = 0;
         ModifiedByName = "<null>";
         ModifiedDate = "<null>";
         ReviewComments = test;
         ReviewStar = 1;
         UserId = 7;
         UserImagePaths = "<null>";
         UserName = " ";
         */
    }
}

/*
 
 {
 
 "OfferTitle": "sampledsfstringdsf2",
 "OfferDescription": "restert",
 "StartDate": "2017-10-15T04:25:25.6619455-04:00",
 "EndDate": "2017-10-15T04:25:25.6619455-04:00",
 "UserId": 2,
 "DealCategories":[
 {
 
 "CategoryId": 2,
 
 },
 {
 
 "CategoryId": 2,
 
 }
 ],
 "DealLocations": [
 {
 
 "StoreLocationId": 2,
 "FileContentCoreEntityList": [
 {
 "FileName": "sample string 1",
 "CDNFilePath": "sample string 2",
 "FileContent": "QEA="
 },
 {
 "FileName": "sample string 1",
 "CDNFilePath": "sample string 2",
 "FileContent": "QEA="
 }
 ],
 
 }
 ],
 }
  api/Deal/Save
 */
