//
//  W2DHomeViewController.swift
//  Walk2Deals
//
//  Created by Rama on 12/17/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import ImageSlideshow
import MapKit

class W2DHomeViewController: UIViewController {

    @IBOutlet weak var homeTbl: UITableView!
    var pageNumber = 1
    var isRefresh = false
    var dealsArray : NSMutableArray = NSMutableArray()
    var recentDealsArray : NSArray = NSArray()
    var topDealsArray : NSArray = NSArray()
    var popularDealsArray : NSArray = NSArray()
    var isGetNearFeeds = false
    var storedOffsets = [Int: CGFloat]()

    
    //PopularDeals
    //RecentDeals
    //TopDeals
    
    
    var currentLocation: CLLocation!
    var locationManager : CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checklocationAuthentication()
       // self.view.backgroundColor = UIColor.gray
        self.homeTbl.backgroundColor = UIColor.clear
        self.setUpSideMenu()
        self.registerCell()
        self.designLeftBarButtonITems()
        if self.currentLocation != nil {
            self.getDeails()
            self.isGetNearFeeds = true
        }
        // Do any additional setup after loading the view.
    }
    
    func designLeftBarButtonITems(){
        let leftButtonsView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 40))
        self.navigationItem.titleView =  leftButtonsView
        
        let titleLable : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        titleLable.textAlignment = .left
        titleLable.textColor = UIColor.white
        titleLable.text = "Walk2Deals"
        //titleLable.text = CXAppConfig.sharedInstance.productName()
        // titleLable.font = CXAppConfig.sharedInstance.appLargeFont()
        leftButtonsView.addSubview(titleLable)
        
        //let dropDownBtn = self.createCartButton("arrow", frame: CGRect(x: titleLable.frame.size.width+10,y: 2, width: 35, height: 35))
        //self.searchBtn.addTarget(self, action: #selector(categoryBtnTapped), for: .touchUpInside)
        
        //leftButtonsView.addSubview(dropDownBtn)
    }
    
    func registerCell(){
        let nib =  UINib(nibName: "BannerTableViewCell", bundle: nil)
        self.homeTbl.register(nib, forCellReuseIdentifier: "BannerTableViewCell")
        
        
        let nib1 =  UINib(nibName: "CollectionViewTblCell", bundle: nil)
        self.homeTbl.register(nib1, forCellReuseIdentifier: "CollectionViewTblCell")
        
        
        let nib2 =  UINib(nibName: "HomeTblCell", bundle: nil)
        self.homeTbl.register(nib2, forCellReuseIdentifier: "HomeTblCell")
        
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
    
    /*
     let imgUrlStr = dic.object(forKey: "URL") as! String
     CXLog.print(imgUrlStr)
     let fileUrl = Foundation.URL(string: imgUrlStr)
     self.sources.append(AFURLSource(url: fileUrl!,placeholder: UIImage(named: "splash_logo")!))
     */
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension W2DHomeViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dealsArray.count > 0 {
            return self.dealsArray.count + 3
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell") as? BannerTableViewCell
            cell?.addTheBannerImage(imageList: self.topDealsArray)
            return cell!
        }else if indexPath.section == 1 || indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTblCell") as? CollectionViewTblCell
            cell!.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
            cell!.collectionViewOffset = storedOffsets[indexPath.section] ?? 0
            if indexPath.section == 1{
                cell?.titleLbl?.text = "Recent Deals"
            }else{
                cell?.titleLbl?.text = "Popular Deals"
            }
            cell?.selectionStyle = .none
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTblCell") as? HomeTblCell
            let dataDict = self.dealsArray[indexPath.section-3] as? NSDictionary
            if let imageUrl = dataDict?.value(forKey: "DealImageUrl") as? String ,!imageUrl.isEmpty {
                let img_Url1 = NSURL(string: imageUrl )
                cell?.dealImgView.setImageWith(img_Url1 as URL!, usingActivityIndicatorStyle: .white)
            }
            var subTitleLbl = ""
            if  let offerTitle = dataDict?.value(forKey: "OfferTitle") as? String{
                cell?.dealTitleLbl.text = offerTitle
                //UserView
                //UserDistance
                //StoreName
                //EndDate
            }
            if  let StoreName = dataDict?.value(forKey: "StoreName") as? String{
                subTitleLbl = StoreName + "• "
            }
            if  let UserView = dataDict?.value(forKey: "UserView") as? Int{
                if UserView == 0 || UserView == 1{
                    subTitleLbl = subTitleLbl + "\(UserView)" + " view• "
                }else{
                    subTitleLbl = subTitleLbl + "\(UserView)" + " views• "
                }
            }
            if  let UserDistance = dataDict?.value(forKey: "UserDistance") as? String{
                //subTitleLbl = subTitleLbl + UserDistance + "."
            }
            if  let EndDate = dataDict?.value(forKey: "EndDate") as? String{
                subTitleLbl = subTitleLbl + "Exp On " + CXAppConfig.sharedInstance.stringToDate(dateString: EndDate)
            }
            if  let distance = dataDict?.value(forKey: "UserDistance") as? String{
                cell?.distanceLbl.text = distance.replacingOccurrences(of: " ", with: "")
            }
            
            if  CXAppConfig.resultString(dataDict?.value(forKey: "UserFav") as AnyObject) == "1" {
                cell?.favBtn.isSelected = true
                if let dealID = (dataDict as AnyObject).value(forKey: "Id") as? Int{
                    CXLog.print(CXDataSaveManager.sharedInstance.isSavedFavourites(postId: "\(dealID)"))
                }
            }else{
                if let dealID = (dataDict as AnyObject).value(forKey: "Id") as? Int{
                    if CXDataSaveManager.sharedInstance.isSavedFavourites(postId: "\(dealID)"){
                        cell?.favBtn.isSelected = true
                    }else{
                        cell?.favBtn.isSelected = false
                    }
                }
            }
            
            cell?.dealSubTitleLbl.text = subTitleLbl
            cell?.selectionStyle = .none
            self.addBorder(cell: cell!)
            
            cell?.favBtn.addTarget(self, action:#selector(favButtonAction(sender:)), for: .touchUpInside)
            cell?.favBtn.tag = indexPath.section
            cell?.shareBtn.addTarget(self, action:#selector(shareButtonAction(sender:)), for: .touchUpInside)
            cell?.shareBtn.tag = indexPath.section
            
            return cell!
        }
        return TableViewCell()
    }
    
    func addBorder(cell:UITableViewCell){
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func favButtonAction(sender:UIButton){
        
        if sender.isSelected {
            return
        }
        
        //http://api.walk2deals.com/api/User/DealsFavSave
        sender.isSelected = !sender.isSelected
        let dataDict = self.dealsArray[sender.tag-3]
        if let dealID = (dataDict as AnyObject).value(forKey: "Id") as? Int{
            CXLog.print(CXDataSaveManager.sharedInstance.isSavedFavourites(postId: "\(dealID)"))
            let parameters = ["DealId":String(dealID),"UserId":CXAppConfig.sharedInstance.getUserID()]
            //{"DealId":"2","UserId":"2"}
            CXDataService.sharedInstance.faveButtonAction(inputDict: parameters)
        }
    }
    
    func shareButtonAction(sender:UIButton){
        // ShareUrl = "http://walk2deals.com//Deal/View/10060";
        let dataDict = self.dealsArray[sender.tag-3]
        if  let shareUrl = (dataDict as AnyObject).value(forKey: "ShareUrl") as? String{
            let activityViewController = UIActivityViewController(activityItems: [shareUrl as NSString], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: {})
        }
       
    }
    
    /* func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CollectionViewTblCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }*/
    
   
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CollectionViewTblCell else { return }
        
        storedOffsets[indexPath.section] = tableViewCell.collectionViewOffset
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 {
            return
        }
        let dataDict = self.dealsArray[indexPath.section-3] as? NSDictionary
        //Id
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let dealDetail = storyBoard.instantiateViewController(withIdentifier: "DealsDetailsViewController") as? DealsDetailsViewController
        dealDetail?.delegate = self
        
        if let dealID = dataDict?.value(forKey: "Id") as? Int{
            dealDetail?.dealId = String(dealID)
        }
        if let offerTitle = dataDict?.value(forKey: "OfferTitle") as? String{
            dealDetail?.navTitle = offerTitle
        }
       
        
        self.navigationController?.pushViewController(dealDetail!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func designBannerView(indexPathe:IndexPath){
        
    }
    
    func designCollectionViewInCell(indexPathe:IndexPath){
        
    }
  /*
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        }else if indexPath.section == 1 || indexPath.section == 2{
            return 150
        }
        return 300
    }
}

extension W2DHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return self.recentDealsArray.count
        }else{
            return self.popularDealsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DealCollectionViewCell", for: indexPath) as? DealCollectionViewCell
        var data = NSDictionary()
        if collectionView.tag == 1 {
            data = (self.recentDealsArray[indexPath.item] as? NSDictionary)!
        }else{
            data = (self.popularDealsArray[indexPath.item] as? NSDictionary)!
        }
        if let imageUrl = data.value(forKey: "DealImageUrl") as? String ,!imageUrl.isEmpty {
            let img_Url1 = NSURL(string: imageUrl )
            cell?.dealImg.setImageWith(img_Url1 as URL!, usingActivityIndicatorStyle: .white)
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
         RedeemCode = W2DEAL011060011029;
         */
        var dataDict = NSDictionary()
        if collectionView.tag == 1 {
            dataDict = (self.recentDealsArray[indexPath.item] as? NSDictionary)!
        }else{
            dataDict = (self.popularDealsArray[indexPath.item] as? NSDictionary)!
        }        //Id
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let dealDetail = storyBoard.instantiateViewController(withIdentifier: "DealsDetailsViewController") as? DealsDetailsViewController
        
        if let dealID = dataDict.value(forKey: "DealId") as? Int{
            dealDetail?.dealId = String(dealID)
        }
        
//        if let offerTitle = dataDict?.value(forKey: "OfferTitle") as? String{
//            dealDetail?.navTitle = offerTitle
//        }
        
        self.navigationController?.pushViewController(dealDetail!, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 150, height: 150);
    }
    
}

extension W2DHomeViewController{
    
    func getDeails(){
        //http://api.walk2deals.com/api/Deal/GetCurrentDeals
        ///api/Deal/DashboardDeals
        //BaseUrl
        let parameters = ["CurrentDate":CXAppConfig.sharedInstance.dateToString(date: Date(), isDisplay: true),"Latitude":String(self.currentLocation.coordinate.latitude)
            ,"Longitude":  String(self.currentLocation.coordinate.longitude)
            ,"UserId":CXAppConfig.sharedInstance.getUserID(),"PageNumber":"\(self.pageNumber)","PageSize":"500"] //PageNumber
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
        CXLog.print(parameters)
        CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+"api/Deal/DashboardDeals", parameters: parameters as! [String : String]) { (responceDic) in
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
                        self.dealsArray = NSMutableArray(array: deals.reversed())
                        
                        if let topdeals =  responceDic.value(forKey: "TopDeals") as? NSArray{
                            self.topDealsArray = NSMutableArray(array: topdeals)
                        }
                        if let recentDeals =  responceDic.value(forKey: "RecentDeals") as? NSArray{
                            self.recentDealsArray = NSMutableArray(array: recentDeals)
                        }
                        if let papulardeals =  responceDic.value(forKey: "PopularDeals") as? NSArray{
                            self.popularDealsArray = NSMutableArray(array: papulardeals)
                        }
                        // DispatchQueue.main.sync {
                        self.homeTbl.reloadData()
                    }else{
                        self.dealsArray.addObjects(from: deals as! [Any])
                       // self.homeCollectionView.reloadData()
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

}
extension W2DHomeViewController:DealDataDelegate{
    func clickFavButton(delaId: String, indexPath: Int) {
        CXLog.print(CXDataSaveManager.sharedInstance.isSavedFavourites(postId: "\(delaId)"))
        self.homeTbl.reloadRows(at: [IndexPath(row: 0, section: indexPath)], with: .middle)
    }
}



extension W2DHomeViewController : LocationServiceDelegate,CLLocationManagerDelegate{
    
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
/*
 Developer Account: sridharpettela@dinspire.in/DinSpire27001

 */
