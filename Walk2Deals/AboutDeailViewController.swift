//
//  AboutDeailViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 05/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class AboutDeailViewController: UIViewController {
    @IBOutlet var aboutDealTbl: UITableView!
    var dealDetailDict : NSDictionary!
        var dealLocatinDict : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CXLog.print("\(dealDetailDict)")
        //DealLocations
       /* self.dealTitle.text = dealDetailDict.value(forKey: "OfferTitle") as? String
        self.dealLocatinDict = dealDetailDict.value(forKey: "DealLocations") as! NSArray
        
        if let strdDate = dealDetailDict.value(forKey: "StartDate") as? String , let endDate = dealDetailDict.value(forKey: "StartDate") as? String {
            self.dealStartLbl.text = "Start Date:  " + strdDate
            self.dealEndLbl.text = "End Date:  " + endDate
        }
        

        if self.dealLocatinDict.count != 0 {
            let dealLocation =  self.dealLocatinDict.lastObject as? NSDictionary
            self.addressLbl.text = dealLocation?.value(forKey: "StoreLocationAddress") as? String
            
            CXLog.print(dealLocation?.value(forKey: "StoreLocationAddress") as? String)

            //StoreLocationAddress
            //Latitude
            //Longitude
        }*/
        //StartDate
        //EndDate
    
        // Do any additional setup after loading the view.
    }

    func registerCell(){
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func locationBtnAction(_ sender: UIButton) {
        let dealLocation =  self.dealLocatinDict.lastObject as? NSDictionary
        let destinationLatitude = Double(dealLocation?.value(forKey: "Latitude")! as! String)
        let destinationLongtitude = Double(dealLocation?.value(forKey: "Longitude")! as! String)
        let googleMapUrlString = String.localizedStringWithFormat("http://maps.google.com/?daddr=%f,%f", destinationLatitude!, destinationLongtitude!)
        UIApplication.shared.openURL(NSURL(string:
            googleMapUrlString)! as URL)
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

extension AboutDeailViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "DealTitleCell") as? DealTitleCell
            titleCell?.dealTitleLbl.text = dealDetailDict.value(forKey: "OfferTitle") as? String
            return titleCell!
        }else if indexPath.row == 1{
            let offerCell = tableView.dequeueReusableCell(withIdentifier: "OfferDetailCell") as? OfferDetailCell
            
            self.dealLocatinDict = dealDetailDict.value(forKey: "DealLocations") as! NSArray
            
            if let strdDate = dealDetailDict.value(forKey: "StartDate") as? String , let endDate = dealDetailDict.value(forKey: "StartDate") as? String {
                //stringToDate
                offerCell?.validStartFromLbl.text = "Start Date:  " + CXAppConfig.sharedInstance.stringToDate(dateString: strdDate)
                offerCell?.validEndOfferLbl.text = "End Date:  " + CXAppConfig.sharedInstance.stringToDate(dateString: endDate)
            }
            
            return offerCell!
        }else{
            let locationCell = tableView.dequeueReusableCell(withIdentifier: "DealLocationCell") as? DealLocationCell
            
            if self.dealLocatinDict.count != 0 {
                let dealLocation =  self.dealLocatinDict.lastObject as? NSDictionary
                locationCell?.locationAddressLbl.text = dealLocation?.value(forKey: "StoreLocationAddress") as? String
                CXLog.print(dealLocation?.value(forKey: "StoreLocationAddress") as? String)
                locationCell?.locationBtn.tag = indexPath.row
                locationCell?.locationBtn.addTarget(self, action:#selector(locationBtnAction(_:)), for: .touchUpInside)
                //StoreLocationAddress
                //Latitude
                //Longitude
            }
            return locationCell!
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 45
        }else if indexPath.row == 1 {
            return 120
        }else{
            return 177
        }
    }
    
   
    
}
