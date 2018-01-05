//
//  AboutDeailViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 05/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class AboutDeailViewController: UIViewController,ExpandCellDelegate {
    @IBOutlet var aboutDealTbl: UITableView!
    var dealDetailDict : NSDictionary!
        var dealLocatinDict : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CXLog.print("\(dealDetailDict)")
        self.aboutDealTbl.rowHeight = UITableViewAutomaticDimension
        self.aboutDealTbl.estimatedRowHeight = 100;
        //let edgeInsets = UIEdgeInsetsMake(0, 20, 0, 20)
        //self.aboutDealTbl.contentInset = edgeInsets

        //DealLocations
  
    }

    func registerCell(){
        
        
    }
    
    // MARK: - my cell delegate
    func moreTapped(cell: OfferDetailCell) {
        
        // this will "refresh" the row heights, without reloading
        aboutDealTbl.beginUpdates()
        aboutDealTbl.endUpdates()
        
        // do anything else you want because the switch was changed
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.dealLocatinDict = dealDetailDict.value(forKey: "DealLocations") as! NSArray

        if indexPath.section == 0 {
            /*
             DealCategories =     (
             {
             CategoryId = 1;
             CategoryName = categoryName;
             Id = 0;
             },
             {
             CategoryId = 2;
             CategoryName = Clothing;
             Id = 0;
             }
             );
             */
            var names = "Category:"
            if let categories = dealDetailDict.value(forKey: "DealCategories") as? NSArray{
                for (index,data)in categories.enumerated(){
                    if let dic = data as? NSDictionary{
                        if let str = dic.value(forKey: "CategoryName") as? String{
                            if index == 0  {
                                names = names + str
                            }else if  index == categories.count-1{
                                names =   names + "," + str
                            }else{
                                names =   names + "," + str

                            }
                        }
                    }
                }
            }
            
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "DealTitleCell") as? DealTitleCell
            titleCell?.dealTitleLbl.text = names
            return titleCell!
        }else if indexPath.section == 2{
            let locationCell = tableView.dequeueReusableCell(withIdentifier: "DealLocationCell") as? DealLocationCell
            var totalAddress = ""
            let dealLocation =  self.dealLocatinDict.lastObject as? NSDictionary

            
            if let storeName = dealLocation?.value(forKey: "StoreLocationName") as? String{
                totalAddress = storeName + ","
            }
            
            if let phoneNumber = dealLocation?.value(forKey: "ContactPhoneNumber") as? String {
                 totalAddress = totalAddress + phoneNumber + ","
            }
            
            if let address = dealLocation?.value(forKey: "StoreLocationAddress") as? String{
                totalAddress = totalAddress + address

            }
            
            

            locationCell?.locationAddressLbl.setHTML(html: totalAddress)
              locationCell?.locationBtn.addTarget(self, action:#selector(locationBtnAction(_:)), for: .touchUpInside)
            return locationCell!
            
            /*
             offerCell?.descriptionLbl.backgroundColor = UIColor(red: 254/255, green: 215/255, blue: 167/255, alpha: 1.0)

             */

        } else {
            let offerCell = tableView.dequeueReusableCell(withIdentifier: "OfferDetailCell") as? OfferDetailCell
            offerCell?.delegate = self
            //OfferDescription
            if indexPath.section == 1{
                offerCell?.viewMoreBtn.isHidden = false
                if let offerDesription = dealDetailDict.value(forKey: "OfferDescription") as? String
                {
                    offerCell?.descriptionLbl.setHTML(html: offerDesription)
                }
            }else if indexPath.section == 3{
                offerCell?.viewMoreBtn.isHidden = false
                if let offerDesription = dealDetailDict.value(forKey: "RedeemDescription") as? String
                {
                    offerCell?.descriptionLbl.setHTML(html: offerDesription)
                }
                offerCell?.descriptionLbl.backgroundColor = UIColor(red: 254/255, green: 215/255, blue: 167/255, alpha: 1.0)

            }else{
                //StoreLocationAddress
                let dealLocation =  self.dealLocatinDict.lastObject as? NSDictionary
                offerCell?.descriptionLbl.setHTML(html: (dealLocation?.value(forKey: "StoreLocationAddress") as? String)!)
                offerCell?.viewMoreBtn.isHidden = true
            }
            
           
           /* if let strdDate = dealDetailDict.value(forKey: "StartDate") as? String , let endDate = dealDetailDict.value(forKey: "EndDate") as? String {
                //stringToDate
                offerCell?.validStartFromLbl.text = "Start Date:  " + CXAppConfig.sharedInstance.stringToDate(dateString: strdDate)
                offerCell?.validEndOfferLbl.text = "End Date:  " + CXAppConfig.sharedInstance.stringToDate(dateString: endDate)
            }*/
            
            return offerCell!
        }/*else{
            let locationCell = tableView.dequeueReusableCell(withIdentifier: "DealLocationCell") as? DealLocationCell
            
            return locationCell!

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
        }*/
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75
        }else if indexPath.section == 1 {
            return UITableViewAutomaticDimension
        }else if indexPath.section == 2{
            return 70
        } else{
            return UITableViewAutomaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
   
    
}

extension UILabel {
    func setHTML(html: String) {
        do {
           let htmlStr = String(format:"<span style=\"font-family: '-apple-system', 'Verdana'; font-size: \(self.font!.pointSize)\">%@</span>", html)
            let at : NSAttributedString = try NSAttributedString(data: htmlStr.data(using: .utf8)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil);
            self.attributedText = at;
        } catch {
            self.text = html;
        }
    }
}
