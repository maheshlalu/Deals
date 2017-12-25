//
//  SelectLocationViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 20/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import MapKit

class SelectLocationViewController: UIViewController {
    var currentLocation: CLLocation!
    var locationManager : CLLocationManager!
    var locatoins : NSMutableArray = NSMutableArray()
    var isGetNearFeeds = false
    @IBOutlet var displayLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checklocationAuthentication()
       self.getLocations()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectLocationAction(_ sender: UIButton) {
        
    }
    
    
    func getLocations(){
        
        let otpUrlString = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getAllLocations()
        CXDataService.sharedInstance.getTheDataFromServer(urlString: otpUrlString, completion: { (responceDic) in
            CXLog.print(responceDic)
            let error = responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
                //Locations
                //self.locatoins =  responceDic.value(forKey: "Locations") as? NSArray
                //Id
                //Name
                self.getCityAddress()
              
            }
            //Locations
        })
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
extension SelectLocationViewController : LocationServiceDelegate,CLLocationManagerDelegate{
    
    //MARK: Checking location authentication
    func checklocationAuthentication(){
        LFLocationService.sharedInstance.delegate = self
        LFLocationService.sharedInstance.startUpdatingLocation()
    }
    
    
    func tracingLocation( _ currentLocation: CLLocation,  _ locationManager: CLLocationManager){
        
        self.currentLocation = locationManager.location
        self.locationManager = locationManager
        if !isGetNearFeeds {
            isGetNearFeeds = true
        }
    }
    
    func tracingLocationDidFailWithError(_ error: NSError){
        
    }
    func tracingLocationDetails(_ currentLocationDetails: CLPlacemark){
        
    }
    
    func getCityAddress(){
        let longitude :CLLocationDegrees = self.currentLocation.coordinate.longitude
        let latitude :CLLocationDegrees = self.currentLocation.coordinate.latitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        // println(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            //println(location)
            
            if error != nil {
                // println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary as Any)
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
                self.checkTheNearDeals(cityNames: city as String)
            }else{
                self.checkTheNearDeals(cityNames: "")
            }
            
            /* if placemarks?.count > 0 {
             // let pm = placemarks[0] as! CLPlacemark
             // println(pm.locality)
             }
             else {
             // println("Problem with the data received from geocoder")
             }*/
        })
    }
    
    func checkTheNearDeals(cityNames:String){
        
        if cityNames.isEmpty {
            //No Deals found near by city
        }else{
            
            for locDict in self.locatoins{
                let dict = locDict as? NSDictionary
                if let name = dict!["Name"] as? String{
                    if cityNames == name{
                        //Save City address and city name in userDefaluts
                        
                    }else{
                        
                    }
                }
            }
        }
    }
    
}
