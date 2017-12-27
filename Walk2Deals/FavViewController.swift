//
//  FavViewController.swift
//  Walk2Deals
//
//  Created by Madhav Bhogapurapu on 11/7/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker

class FavViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var favourateTableView: UITableView!
    
    var placesClient: GMSPlacesClient!
    var currentPlace: GMSPlace!
    let locationManager = CLLocationManager()

    var name: UITextView!
    var contactName: UITextView!
    var phoneNumber: UITextView!
    var anotherNumber: UITextView!
    var email: UITextView!
    var address: UITextView!
    var selectedLocationInfoDic: Dictionary? = [String: String]()
    var latitude : String!
    var longitude : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.askLocationpermissionForASAP()
        placesClient = GMSPlacesClient.shared()
        self.getUserCurrentLocation()
        let nib = UINib(nibName: "FavourateTableViewCell", bundle: nil)
        self.favourateTableView.register(nib, forCellReuseIdentifier: "FavourateTableViewCell")
        self.title = "Request For Ad"
        
        self.setUpBackButton()
        // Do any additional setup after loading the view.
    }
    
    func setUpBackButton(){
        let menuItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(RequestForAddController.backAction(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            
        }
    }
    func askLocationpermissionForASAP() {
        self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.requestAlwaysAuthorization()
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavourateTableViewCell", for: indexPath)as? FavourateTableViewCell
        
         self.name = (cell?.name)!
         self.contactName = (cell?.contactName)!
         
         self.phoneNumber = (cell?.phoneNumber)!
         self.anotherNumber = (cell?.anotherNumber)!
         self.email = (cell?.email)!
         self.address = (cell?.address)!
        
        cell?.chageAddressAction.addTarget(self, action:#selector(pickAddress(sender:)), for: .touchUpInside)
        
        return cell!
    }
    func pickAddress(sender:UIButton){
        // ShareUrl = "http://walk2deals.com//Deal/View/10060";
     self.pickYourLocation()
    }
    
    func validatedTextView(){
      
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 640
    }
    
   
    @IBAction func cancelAction(_ sender: Any) {
        self.backAction(sender: sender as! UIButton)
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

extension FavViewController{
    
    func pickYourLocation(){
        
        
            
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    
                    let alert = UIAlertController(title: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Location Service for this app.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { (_action) in
                        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    
                    let center: CLLocationCoordinate2D!
                    if self.currentPlace != nil {
                        center = self.currentPlace.coordinate
                    } else {
                        
                        center = CLLocationCoordinate2D(latitude: Double((self.selectedLocationInfoDic?["Latitude"]!)!)!, longitude: Double((self.selectedLocationInfoDic?["Longitude"]!)!)!)
                    }
                    
                    self.view.endEditing(true)
                    
                    let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
                    let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
                    let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
                    let config = GMSPlacePickerConfig(viewport: viewport)
                    let placePicker = GMSPlacePicker(config: config)
                    //        UIApplication.shared.statusBarStyle = .default
                    
                    UINavigationBar.appearance().tintColor = UIColor.white
                   // UINavigationBar.appearance().backgroundColor = UIColor.blue
                   // UINavigationBar.appearance().barTintColor = UIColor.blue
                    
                    let barBtnFont = UIFont(name: "MyriadPro-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)
                    let navbarFont = UIFont(name: "MyriadPro-Semibold", size: 18) ?? UIFont.systemFont(ofSize: 18)
                    
                    UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: navbarFont, NSForegroundColorAttributeName:UIColor.white]
                    UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: barBtnFont, NSForegroundColorAttributeName:UIColor.white], for: UIControlState.normal)
                    
                   // UISearchBar.appearance().barTintColor = UIColor.blue
                    UISearchBar.appearance().tintColor = UIColor.white
                    
                    let yourAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 16.0)]
                    (UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])).defaultTextAttributes = yourAttributes
                    
                    placePicker.pickPlace(callback: {(place, error) -> Void in
                        
                        UIApplication.shared.statusBarStyle = .lightContent
                        if let error = error {
                            print("Pick Place error: \(error.localizedDescription)")
                            return
                        }
                        if let place = place {
                            if place.addressComponents != nil {
                                for component in (place.addressComponents!) {
                                }
                            }
                        }
                        
                        if let place = place {
                            
                            if place.formattedAddress != nil {
                                self.address.text = place.name + place.formattedAddress!

                            } else {
                                
                                self.placesClient.lookUpPlaceID(place.placeID, callback: { (newPlace, error) in
                                    
                                    if let error = error {
                                        print("lookup place id query error: \(error.localizedDescription)")
                                        
                                        return
                                    }
                                    
                                    guard newPlace != nil else {
                                        print("No place details for \(place.placeID)")
                                        return
                                    }
                                    
                                    if let place = newPlace {
                                        
                                        if place.formattedAddress != nil {
                                            self.address.text = place.formattedAddress
                                            
                                        }
                                        
                                        
                                    }
                                })
                                
                            }
                            
                        } else {
                           
                        }
                    })
                    
                    break
                }
            } else {
                let alert = UIAlertController(title: "Turn On Location Services to Allow ASAP to Determine Your Location", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { (_action) in
                    UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        
    }
    
    func getUserCurrentLocation() {
      
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                //self.locationPickupBtn.isEnabled = true
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
           // self.locationLabel.text = "Please wait, we are loading your current location"
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    if place.addressComponents != nil {
                        for component in place.addressComponents! {
                            
                        }
                        
                    }
                    CXLog.print("\(place.coordinate.longitude)")
                    CXLog.print("\(place.name + place.formattedAddress!)")
                    self.address.text = place.name + place.formattedAddress!

                    self.longitude = "\(place.coordinate.longitude)"
                    self.latitude = "\(place.coordinate.latitude)"
                    self.selectedLocationInfoDic?["Latitude"] = "\(place.coordinate.latitude)"
                    self.selectedLocationInfoDic?["Longitude"] = "\(place.coordinate.longitude)"
                   // self.selectedLocationInfoDic?["City"] = "\(place.)"

                    
                }
            }
        })
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if self.name.text.characters.count == 0 || self.contactName.text.characters.count == 0 || self.phoneNumber.text.characters.count == 0 || self.anotherNumber.text.characters.count == 0 || self.email.text.characters.count == 0 || self.address.text.characters.count == 0{
            CXDataService.sharedInstance.showAlert(message: "Please Enter Required Fields", viewController: self)
        }else{
            self.selectedLocationInfoDic!["StoreName"] = self.name.text
            self.selectedLocationInfoDic!["ContactPerson"] = self.contactName.text
            self.selectedLocationInfoDic!["ContactNumber"] = self.phoneNumber.text
        self.backAction(sender: UIButton())
            
            self.selectedLocationInfoDic!["UserId"] = CXDataSaveManager.sharedInstance.getTheUserProfileFromDB().userId
        CXDataService.sharedInstance.postTheDataToServer(urlString: "http://api.walk2deals.com/api/Store/Request", parameters: self.selectedLocationInfoDic!) { (responce) in
            
        }
        }
    }
}



/*
 [12/11/17, 11:04:15 PM] Sridhar Pettela: {
 "StoreName":"TestStoreName",
 "UserId":5,
 "LocationId":1,
 "ContactPerson":"Testing",
 "ContactNumber":"8989898989",
 "Latitude":"17.690474",
 "Longitude":"83.231049",
 "Address1":"234234",
 "Address2":"23423",
 "City":"Visakhapatnam",
 "State":"AP",
 "ZipCode":"530041",
 }
 [12/11/17, 11:05:49 PM] Sridhar Pettela: http://api.walk2deals.com/api/Store/Request
 */
