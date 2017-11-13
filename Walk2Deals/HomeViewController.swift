//
//  HomeViewController.swift
//  Walk2Deals
//
//  Created by apple on 23/09/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import MapKit
class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var currentLocation: CLLocation!
    var locationManager : CLLocationManager!
    var dealsArray : NSMutableArray = NSMutableArray()
    var isGetNearFeeds = false
    
    var notificationBtn : MIBadgeButton!
    var searchBtn : MIBadgeButton!
    var pageNumber = 0
    var isRefresh = false
    
    let delgate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checklocationAuthentication()
        self.homeCollectionView.backgroundColor = UIColor.clear
        self.setUpSideMenu()
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        self.homeCollectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        self.homeCollectionView.contentInset = UIEdgeInsetsMake(5, 10, 10, 10)
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        self.addBarButtonItems()
        self.designLeftBarButtonITems()
        self.notificationRegister()
    }
    
    func notificationRegister(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reloadHomeFeed), name: NSNotification.Name(rawValue: "reloadData"), object: nil)

    }
    
    func reloadHomeFeed(){
        self.getDeails()
    }
    
    //MARK: Right Bar button
    func addBarButtonItems(){
        let rightButtonsView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        let buttondWidth : CGFloat = 35
        var buttonXposition : CGFloat = rightButtonsView.frame.size.width-buttondWidth+12
        self.notificationBtn = self.createCartButton("whiteNotification", frame: CGRect(x: buttonXposition,y: 2, width: 35, height: 35))
        self.notificationBtn.addTarget(self, action: #selector(notificationBtnTapped), for: .touchUpInside)
        buttonXposition =  buttonXposition-notificationBtn.frame.size.width-20
        self.searchBtn = self.createCartButton("search", frame: CGRect(x: buttonXposition, y: 1, width: 35, height: 35))
        self.searchBtn.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        rightButtonsView.addSubview(notificationBtn)
        rightButtonsView.addSubview(searchBtn)
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: rightButtonsView)
        
    }
    
    func notificationBtnTapped(_ sender:UIButton){

    }
    
    func searchBtnTapped(_ sender:UIButton){
        
    }
    func createCartButton(_ imageName:String,frame:CGRect) -> MIBadgeButton {
        
        let button = MIBadgeButton(type: .custom) as MIBadgeButton
        button.setBackgroundImage(UIImage(named:imageName), for: UIControlState())
        button.frame =  frame
        button.badgeTextColor = UIColor.red
        button.badgeBackgroundColor = UIColor.white
        button.badgeEdgeInsets = UIEdgeInsetsMake(13, 5, 0, 10)
        return button
    }
    
    //MARK: Left Bar button item
    
    func designLeftBarButtonITems(){
        let leftButtonsView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 40))
        self.navigationItem.titleView =  leftButtonsView
        
        let titleLable : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        titleLable.textAlignment = .left
        titleLable.textColor = UIColor.white
        titleLable.text = "Categories"
        //titleLable.text = CXAppConfig.sharedInstance.productName()
       // titleLable.font = CXAppConfig.sharedInstance.appLargeFont()
        leftButtonsView.addSubview(titleLable)
        
        let dropDownBtn = self.createCartButton("arrow", frame: CGRect(x: titleLable.frame.size.width+10,y: 2, width: 35, height: 35))
        self.searchBtn.addTarget(self, action: #selector(categoryBtnTapped), for: .touchUpInside)

        leftButtonsView.addSubview(dropDownBtn)
      

    }
    
    func categoryBtnTapped(_ sender:UIButton){
        
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
    
    func setUpSideMenu(){
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
}

extension HomeViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
     
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.dealsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : HomeCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath)as? HomeCollectionViewCell)!
        let dataDict = self.dealsArray[indexPath.row] as? NSDictionary
       /* if let imageUrlArray = dataDict?.value(forKey: "ImageCDNUrls") as? NSArray , imageUrlArray.count != 0{
            if let imgStr = imageUrlArray.lastObject as? String {
                let img_Url1 = NSURL(string: imgStr )
                cell.categoryImageView.setImageWith(img_Url1 as URL!, usingActivityIndicatorStyle: .white)
            }
            
        }*/
        
        if let imageUrl = dataDict?.value(forKey: "DealImageUrl") as? String ,!imageUrl.isEmpty {
                let img_Url1 = NSURL(string: imageUrl )
                cell.categoryImageView.setImageWith(img_Url1 as URL!, usingActivityIndicatorStyle: .white)
            
        }
        //DealImageUrl
        //OfferTitle
        if  let offerTitle = dataDict?.value(forKey: "OfferTitle") as? String{
            cell.offerTitleLbl.text = offerTitle
        }
        
        if  let distance = dataDict?.value(forKey: "UserDistance") as? String{
            cell.distanceLbl.text = distance + "Km"
        }
        if  CXAppConfig.resultString(dataDict?.value(forKey: "UserFavDeal") as AnyObject) == "1" {
            cell.favBtn.isSelected = true
            if let dealID = (dataDict as AnyObject).value(forKey: "Id") as? Int{
                CXLog.print(CXDataSaveManager.sharedInstance.isSavedFavourites(postId: "\(dealID)"))
            }
        }else{
            if let dealID = (dataDict as AnyObject).value(forKey: "Id") as? Int{
                if CXDataSaveManager.sharedInstance.isSavedFavourites(postId: "\(dealID)"){
                    cell.favBtn.isSelected = true

                }else{
                    cell.favBtn.isSelected = false
                }
            }
        }
        cell.favBtn.addTarget(self, action:#selector(favButtonAction(sender:)), for: .touchUpInside)
        cell.favBtn.tag = indexPath.row
        cell.shareBtn.addTarget(self, action:#selector(shareButtonAction(sender:)), for: .touchUpInside)
        cell.shareBtn.tag = indexPath.row
        //UserDistance
        return cell
        
        
    }
    
    func favButtonAction(sender:UIButton){
        
        if sender.isSelected {
            return
        }

        //http://api.walk2deals.com/api/User/DealsFavSave
        sender.isSelected = !sender.isSelected
        let dataDict = self.dealsArray[sender.tag]
        if let dealID = (dataDict as AnyObject).value(forKey: "Id") as? Int{
            CXLog.print(CXDataSaveManager.sharedInstance.isSavedFavourites(postId: "\(dealID)"))
            let parameters = ["DealId":String(dealID),"UserId":CXAppConfig.sharedInstance.getUserID()]
            //{"DealId":"2","UserId":"2"}
            CXDataService.sharedInstance.faveButtonAction(inputDict: parameters)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.bounds.width/1-9, height: 200)
        return CGSize(width: collectionView.bounds.width-20, height: 300)
    }
    
    
    func shareButtonAction(sender:UIButton){
        let activityViewController = UIActivityViewController(activityItems: ["" as NSString], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: {})
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let dataDict = self.dealsArray[indexPath.row] as? NSDictionary
        //Id
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let dealDetail = storyBoard.instantiateViewController(withIdentifier: "DealsDetailsViewController") as? DealsDetailsViewController
        
        if let dealID = dataDict?.value(forKey: "Id") as? Int{
            dealDetail?.dealId = String(dealID)
        }
        
            self.navigationController?.pushViewController(dealDetail!, animated: true)

    }
    
}

//MARK: FIRBASE Listener
extension HomeViewController : LocationServiceDelegate,CLLocationManagerDelegate{
    
    //MARK: Checking location authentication
    func checklocationAuthentication(){
        LFLocationService.sharedInstance.delegate = self
        LFLocationService.sharedInstance.startUpdatingLocation()
    }

    
    func tracingLocation( _ currentLocation: CLLocation,  _ locationManager: CLLocationManager){
        
        self.currentLocation = locationManager.location
        self.locationManager = locationManager
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

extension HomeViewController{
    
    
    func getDeails(){
        
        //http://api.walk2deals.com/api/Deal/GetCurrentDeals
        
        let parameters = ["CurrentDate":CXAppConfig.sharedInstance.dateToString(date: Date(), isDisplay: true),"Latitude":String(self.currentLocation.coordinate.latitude)
            ,"Longitude":        String(self.currentLocation.coordinate.longitude)
            ,"UserId":CXAppConfig.sharedInstance.getUserID(),"PageNumber":"\(self.pageNumber)","PageSize":"10"] //PageNumber
        
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
        CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getDealsUrl(), parameters: parameters as! [String : String]) { (responceDic) in
            CXLog.print("responce dict \(responceDic)")
            CXDataService.sharedInstance.hideLoader()
            let error =  responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
                if let deals =  responceDic.value(forKey: "Deals") as? NSArray{
                    if deals.count == 0{
                    return
                }
                if self.pageNumber == 1{
                    self.dealsArray = NSMutableArray(array: deals)
                    // DispatchQueue.main.sync {
                    self.homeCollectionView.reloadData()
                }else{
                    
                    self.dealsArray.addObjects(from: deals as! [Any])
                    self.homeCollectionView.reloadData()
                }
                self.isRefresh = false
                //}
                }else{
                    
                }
            }else{
                CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == self.dealsArray.count - 1 && !self.isRefresh{
            self.pageNumber += 1
            self.isRefresh = true
            self.getDeails()
            
        }
    }
    
}

