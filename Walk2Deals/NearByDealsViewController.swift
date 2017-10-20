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
    var latAndLongData = NSMutableArray()
    var dealsArray : NSMutableArray = NSMutableArray()
    var isGetNearFeeds = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSideMenu()
        self.getDeails()

        // Do any additional setup after loading the view.
    }

    func setUpSideMenu(){
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
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
                self.parsingMapAnnotations(list: self.dealsArray)
                // DispatchQueue.main.sync {
               // self.homeCollectionView.reloadData()
                //}
            }else{
                CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
            }
            
        }
        
    }
    
    func parsingMapAnnotations(list:NSArray){
        
        for data in list {
            let dict = data as? NSDictionary
            let center = CLLocationCoordinate2D(latitude: (dict?.value(forKey: "Latitude")! as AnyObject).doubleValue!, longitude: (dict?.value(forKey: "Longitude")! as AnyObject).doubleValue!)
            let point = StarbucksAnnotation(coordinate: center)
           let locations = dict?.value(forKey: "DealLocations") as! NSArray
            if locations.count != 0 {
                let dealLocation =  locations.lastObject as? NSDictionary
                 point.address = dealLocation?.value(forKey: "StoreLocationAddress") as? String
                //StoreLocationAddress
                //Latitude
                //Longitude
            }
          //  point.address = CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: dict!, sourceKey: "formatted_address")
             if let dealID = (dict as AnyObject).value(forKey: "Id") as? Int{
                point.idstr = String(dealID)
            }
            point.name = CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: dict!, sourceKey: "OfferTitle")
            
            if let imageUrlArray = dict?.value(forKey: "ImageCDNUrls") as? NSArray , imageUrlArray.count != 0{
                let imgStr = imageUrlArray.lastObject as? String
                point.image  = URL(string: imgStr!)
            }
            self.mapviewPlaces.addAnnotation(point)
            self.latAndLongData.add(point)
        }
    }
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        var annotationView = self.mapviewPlaces.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "MapPin")
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        if view.annotation is MKUserLocation{
            // Don't proceed with custom callout
            return
        }
        //
        let starbucksAnnotation = view.annotation as! StarbucksAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.starbucksName.text = starbucksAnnotation.name
        calloutView.starbucksAddress.text = starbucksAnnotation.address
        calloutView.starbucksPhone.text = starbucksAnnotation.idstr
        
        let button = UIButton(frame: calloutView.starbucksPhone.frame)
        //button.addTarget(self, action: #selector(LFSearchPlacesViewController.callRestrarent(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        if let imageUrl = starbucksAnnotation.image {
            calloutView.starbucksImage.setImageWith(imageUrl, usingActivityIndicatorStyle: .white)
        }
        
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.46)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
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

/*
 
 {
 
 "OfferTitle": "sampledsfssdgfhfh789fsfringdsf2",
 "OfferDescription": "reste87fghfgh9sdfsdfrt",
 "StartDate": "2017-10-15T04:25:25.6619455-04:00",
 "EndDate": "2017-10-15T04:25:25.6619455-04:00",
 "UserId": 2,
 "DealCategories":[
 {
 
 "CategoryId": 6,
 
 }
 
 ],
 "DealLocations": [
 {
 "StoreLocationId": 1,
 "FileContentCoreEntityList": [
 {
 "FileName": "fdgdgfdg",
 "CDNFilePath": "dfgdfgdfg",
 "FileContent": "00000000000000000000000001100100"
 }
 
 ],
 "IsActive": true,
 
 }
 }
 */
