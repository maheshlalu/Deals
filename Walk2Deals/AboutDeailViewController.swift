//
//  AboutDeailViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 05/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class AboutDeailViewController: UIViewController {
    var dealDetailDict : NSDictionary!

    @IBOutlet weak var dealStartLbl: UILabel!
    @IBOutlet weak var dealTitle: UILabel!
    @IBOutlet weak var dealEndLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    var dealLocatinDict : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CXLog.print("\(dealDetailDict)")
        //DealLocations
        self.dealTitle.text = dealDetailDict.value(forKey: "OfferTitle") as? String
        self.dealLocatinDict = dealDetailDict.value(forKey: "DealLocations") as! NSArray
        if self.dealLocatinDict.count != 0 {
            let dealLocation =  self.dealLocatinDict.lastObject as? NSDictionary
            self.addressLbl.text = dealLocation?.value(forKey: "StoreLocationAddress") as? String
            //StoreLocationAddress
            //Latitude
            //Longitude
        }
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationBtnAction(_ sender: UIButton) {
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
