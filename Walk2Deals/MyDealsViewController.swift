//
//  MyDealsViewController.swift
//  Walk2Deals
//
//  Created by Madhav Bhogapurapu on 11/7/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class MyDealsViewController: UIViewController {
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var dealsArray : NSMutableArray = NSMutableArray()

    var isFavDeal = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeCollectionView.backgroundColor = UIColor.clear
        self.setUpSideMenu()
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        self.homeCollectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        self.homeCollectionView.contentInset = UIEdgeInsetsMake(5, 10, 10, 10)
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        // self.addBarButtonItems()
        // Do any additional setup after loading the view.
        self.getMyDeals()
        if self.isFavDeal {
            self.title = "Favourites"
        }else{
            self.title = "My Deals"
        }
    }
    //MARK: Left Bar button item
    
    func setUpSideMenu(){
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    

    func getMyDeals(){
       /*
         http://api.walk2deals.com/api/Deal/MyDeals/
         jsonObject.put("UserId",SharedPref.read(Constants.PREF_USER_ID,""));
         http://api.walk2deals.com/api/Deal/GetFavouriteDeals
         post - UserId=18
         */
        self.dealsArray = NSMutableArray()
        if isFavDeal {
           // http://api.walk2deals.com/api/Deal/GetFavouriteDeals
           // post - UserId=18
            let parameters = ["UserId":CXAppConfig.sharedInstance.getUserID()] //PageNumber
            CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
            CXLog.print(parameters)
            CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+"api/Deal/GetFavouriteDeals" ,parameters: parameters as! [String : String]) { (responceDic) in
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
                            self.dealsArray.addObjects(from: deals as! [Any])
                            self.homeCollectionView.reloadData()
                        //}
                    }else{
                        
                    }
                }else{
                    CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
                }
            }
        }else{
            
            
            
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

}

extension MyDealsViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
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
        if let offerTitle = dataDict?.value(forKey: "OfferTitle") as? String{
            dealDetail?.navTitle = offerTitle
        }
        
        self.navigationController?.pushViewController(dealDetail!, animated: true)
        
    }
    
}
