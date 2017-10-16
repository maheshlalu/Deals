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
    var dealsArray : NSMutableArray = NSMutableArray()
    var isGetNearFeeds = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checklocationAuthentication()
        self.homeCollectionView.backgroundColor = UIColor.clear
        self.setUpSideMenu()
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        self.homeCollectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        // Do any additional setup after loading the view.
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
                    self.homeCollectionView.reloadData()
                //}
            }else{
                CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
            }
            
        }

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
        
        //cell.categoryImageView.image = UIImage(named: "sampleDeal")
        // cell.categoryImageView.setImageWithURL(NSURL(string:CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(categoryDic, sourceKey: "Image_URL")), usingActivityIndicatorStyle: .Gray)
    //  dealsArraydealsArray  cell.subCategoryLbl.text =  categoryDic.value(forKey: "Name") as? String
        // cell.subCategoryLbl.text = categoryDic
        
        //cell.favBtn.addTarget(self, action: #, for: .touchUpInside)
        //ImageCDNUrls
        
        if let imageUrlArray = dataDict?.value(forKey: "ImageCDNUrls") as? NSArray{
            let imgStr = imageUrlArray.lastObject as? String
            let img_Url1 = NSURL(string: imgStr! )
            cell.categoryImageView.setImageWith(img_Url1 as URL!, usingActivityIndicatorStyle: .white)
        }
        //OfferTitle
        if  let offerTitle = dataDict?.value(forKey: "OfferTitle") as? String{
            cell.offerTitleLbl.text = offerTitle
        }
        
        cell.favBtn.addTarget(self, action:#selector(favButtonAction(sender:)), for: .touchUpInside)
        cell.favBtn.tag = indexPath.row

        cell.shareBtn.addTarget(self, action:#selector(shareButtonAction(sender:)), for: .touchUpInside)

        cell.shareBtn.tag = indexPath.row

        return cell
        
        
    }
    
    func favButtonAction(sender:UIButton){
        //http://api.walk2deals.com/api/User/DealsFavSave
        
        sender.isSelected = !sender.isSelected
        let dataDict = self.dealsArray[sender.tag]
        if let dealID = (dataDict as AnyObject).value(forKey: "Id") as? Int{
            let parameters = ["DealId":String(dealID),"UserId":CXAppConfig.sharedInstance.getUserID()]
            //{"DealId":"2","UserId":"2"}
            CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSaveFavouriteUrl(), parameters: parameters) { (responceDic) in
                CXLog.print("responce dict \(responceDic)")
                let error =  responceDic.value(forKey: "Errors") as? NSArray
                let errorDict = error?.lastObject as? NSDictionary
                let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
                if errorcode == "0"{
                    //let deals =  responceDic.value(forKey: "Deals") as? NSArray
                    // self.dealsArray = NSMutableArray(array: deals!)
                }else{
                    CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.bounds.width/1-9, height: 200)
        return CGSize(width: collectionView.bounds.width-10, height: 250)
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

