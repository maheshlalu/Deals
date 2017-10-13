//
//  NearByDealsViewController.swift
//  Walk2Deals
//
//  Created by apple on 13/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import MapKit

class NearByDealsViewController: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var mapviewPlaces: MKMapView!
    var currentLocation: CLLocation!
    var dealsArray : NSMutableArray = NSMutableArray()
    var isGetNearFeeds = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDeails(){
        
        //http://api.walk2deals.com/api/Deal/GetCurrentDeals
        
        let parameters = ["CurrentDate":"","Latitude":"","Longitude":"","Location":"1","LocationId":""]
        
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
        
        CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getDealsUrl(), parameters: parameters as! [String : String]) { (responceDic) in
            CXLog.print("responce dict \(responceDic)")
            CXDataService.sharedInstance.hideLoader()
            let error =  responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
                let deals =  responceDic.value(forKey: "Deals") as? NSArray
                self.dealsArray = NSMutableArray(array: deals!)
                // DispatchQueue.main.sync {
               // self.homeCollectionView.reloadData()
                //}
            }else{
                CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
            }
            
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

//MARK: FIRBASE Listener
extension NearByDealsViewController : LocationServiceDelegate,CLLocationManagerDelegate{
    
    //MARK: Checking location authentication
    func checklocationAuthentication(){
        LFLocationService.sharedInstance.delegate = self
        LFLocationService.sharedInstance.startUpdatingLocation()
    }
    
    
    func tracingLocation( _ currentLocation: CLLocation,  _ locationManager: CLLocationManager){
        
        self.currentLocation = locationManager.location
        
        if !isGetNearFeeds {
            self.getDeails()
            isGetNearFeeds = true
        }
    }
    
    func tracingLocationDidFailWithError(_ error: NSError){
        
    }
    func tracingLocationDetails(_ currentLocationDetails: CLPlacemark){
        
    }
    
}
