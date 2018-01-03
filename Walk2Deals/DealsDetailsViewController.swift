//
//  DealsDetailsViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 05/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class DealsDetailsViewController: UIViewController {

    
    @IBOutlet weak var rattingView: FloatRatingView!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var offerBtn: UIButton!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: UIViewController?
    @IBOutlet weak var pagerView: KIImagePager!
    var coverPageImagesList: NSMutableArray!
    var pageMenu : CAPSPageMenu?
    var dealId :String?
    @IBOutlet weak var pagerHeight: NSLayoutConstraint!
    @IBOutlet weak var writeReviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var reedemBtn: UIButton!
    
    @IBOutlet weak var dealOfferDate: UILabel!
    @IBOutlet weak var writeReviewBtn: UIButton!
    @IBOutlet weak var rattingLbl: UILabel!
    var navTitle = ""
    var dealDetailDict : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDealDataByID()
        self.title = self.navTitle
        //CXLog.print(dealId)
        // Do any additional setup after loading the view.
    }
    
    
    func setUpTabPager(){
        let color =  UIColor(red: 79/255.0, green: 112/255.0, blue: 157/255.0, alpha: 1.0)
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorColor(UIColor.white),
            .selectedMenuItemLabelColor(UIColor.white),
            .menuHeight(55),
            .scrollMenuBackgroundColor(color),
            .menuItemWidth(self.view.frame.size.width/2-16)
        ]
        var contrl = [UIViewController]()
        let aboutDeal : AboutDeailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutDeailViewController") as! AboutDeailViewController
        aboutDeal.title = "About"
        aboutDeal.dealDetailDict = self.dealDetailDict
       
        let reviewsVc : ReviewListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewListViewController") as! ReviewListViewController
        reviewsVc.title = "Reviews"
        reviewsVc.dealDetailDict = self.dealDetailDict
        ///ReviewListViewController
        contrl.append(aboutDeal)
        contrl.append(reviewsVc)

        
        let profile = CXDataSaveManager.sharedInstance.getTheUserProfileFromDB()
        if profile.isUser {
            //self.reedemBtn.isHidden = false
        }else{
            let approveVc : ApproveViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ApproveViewController") as! ApproveViewController
            approveVc.title = "Redeem"
            approveVc.dealDetailDict = self.dealDetailDict
            //contrl.append(approveVc)
            self.reedemBtn.isHidden = true
        }
        
        let pagerHeight = UIScreen.main.bounds.size.height - (self.pagerHeight.constant + self.writeReviewHeight.constant + 70)
        
        self.pageMenu = CAPSPageMenu(viewControllers: contrl, frame: CGRect(x: 0, y: self.pagerHeight.constant+1+50, width: self.view.frame.width, height: pagerHeight-50), pageMenuOptions: parameters)
        self.view.addSubview((self.pageMenu?.view)!)
    }
    
    
    func getDealDataByID(){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
       // http://api.walk2deals.com/api/Deal/GetById/2
        let otpUrlString = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getDealByIDUrl() + "\(self.dealId!)" + "/" + "\(CXAppConfig.sharedInstance.getUserID())"
        CXDataService.sharedInstance.getTheDataFromServer(urlString: otpUrlString, completion: { (responceDic) in
            CXLog.print(" deail deatil dic\(responceDic)")
            self.dealDetailDict = responceDic
            CXDataService.sharedInstance.hideLoader()
            self.populatedTheData()
            })
    }
    
    @IBAction func favBtnAction(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        //http://api.walk2deals.com/api/User/DealsFavSave
        sender.isSelected = !sender.isSelected
        let dataDict = self.dealDetailDict
        if let dealID = (dataDict as AnyObject).value(forKey: "Id") as? Int{
            let parameters = ["DealId":String(dealID),"UserId":CXAppConfig.sharedInstance.getUserID()]
            //{"DealId":"2","UserId":"2"}
            CXDataService.sharedInstance.faveButtonAction(inputDict: parameters)
        }
    }
    @IBAction func shareAction(_ sender: UIButton) {
        let dataDict = self.dealDetailDict
        if  let shareUrl = (dataDict as AnyObject).value(forKey: "ShareUrl") as? String{
            let activityViewController = UIActivityViewController(activityItems: [shareUrl as NSString], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: {})
        }
    }
    
    func populatedTheData(){
        
       /* let myString:NSString = CXAppConfig.resultString(self.dealDetailDict.value(forKey: "DealReviewStars") as AnyObject) as NSString
        if myString.length != 0 {
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Roboto-Regular", size: 14.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:2,length:myString.length))
            // set label Attribute
            self.rattingLbl.attributedText = myMutableString
        }*/
     
        //IsRedeemed
        //reedemBtn
        //    RedeemCode = W2DEAL011060011029;

        if let RedeemCode = self.dealDetailDict?.value(forKey: "RedeemCode") as? String{
            CXLog.print(RedeemCode)
            self.reedemBtn.isHidden = true
        }else{
            self.reedemBtn.isHidden = false
        }
        //ShowAddReview
        
        if  CXAppConfig.resultString(self.dealDetailDict?.value(forKey: "ShowAddReview") as AnyObject) == "1" {
            self.writeReviewBtn.isHidden = true
        }else{
            self.writeReviewBtn.isHidden = false
        }
        
        
        if  CXAppConfig.resultString(self.dealDetailDict?.value(forKey: "UserFavDeal") as AnyObject) == "1" {
            self.mapBtn.isSelected = true
            //cell?.favBtn.isSelected = true
            if let dealID = (self.dealDetailDict as AnyObject).value(forKey: "Id") as? Int{
                CXLog.print(CXDataSaveManager.sharedInstance.isSavedFavourites(postId: "\(dealID)"))
            }
        }else{
            if let dealID = (self.dealDetailDict as AnyObject).value(forKey: "Id") as? Int{
                if CXDataSaveManager.sharedInstance.isSavedFavourites(postId: "\(dealID)"){
                  //  cell?.favBtn.isSelected = true
                    self.mapBtn.isSelected = true
                }else{
                    self.mapBtn.isSelected = false
                   // cell?.favBtn.isSelected = false
                }
            }
        }
        
        if let strdDate = dealDetailDict.value(forKey: "StartDate") as? String , let endDate = dealDetailDict.value(forKey: "EndDate") as? String {
            
            let validStr = "Valid From:\(CXAppConfig.sharedInstance.stringToDate(dateString: strdDate)) - \(CXAppConfig.sharedInstance.stringToDate(dateString: endDate))"
            //self.dealOfferDate.text = validStr
        
            //self.dealOfferDate.backgroundColor = UIColor(white: 1, alpha: 0.5)
          
        }

        //DealReviewStars
            self.rattingView.rating = Float(CXAppConfig.resultString(self.dealDetailDict.value(forKey: "DealReviewStars") as AnyObject))!
        self.setUpTabPager()
        self.imageViewAimations(dealsDic: self.dealDetailDict)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageViewAimations(dealsDic:NSDictionary){
        
        // var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(timerCall()), userInfo: nil, repeats: true)
        
        self.coverPageImagesList = NSMutableArray()
       //let attachements: NSArray = dealsDic.value(forKey: "ImageCDNUrls") as! NSArray
        
        if let attachements = dealDetailDict.value(forKey: "ImageCDNUrls") as? NSArray , attachements.count != 0{
            // let attachements: NSArray = CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(dealsDic, sourceKey: "Attachments") as! NSArray
            for imageDic in attachements {
                self.coverPageImagesList.add(imageDic)
            }
            self.pagerView.delegate = self
            self.pagerView.dataSource = self
            self.pagerView.checkWetherToToggleSlideshowTimer()
            self.pagerView.slideshowTimeInterval = 3
            self.pagerView.reloadData()
           // self.pagerView.addSubview(self.dealOfferDate)
        }
    }

   
    @IBAction func writeReviewBtnAction(_ sender: UIButton) {
        let storyBaord = UIStoryboard(name: "Main", bundle: nil)
        let writeReviewVc = storyBaord.instantiateViewController(withIdentifier: "WriteReviewViewController") as? WriteReviewViewController
        writeReviewVc?.dealID = self.dealId
        writeReviewVc?.delegate = self
        self.navigationController?.pushViewController(writeReviewVc!, animated: true)
    }
    @IBAction func reedemBtnAction(_ sender: UIButton) {
        /*
         POST /api/Deal/SaveRedeem
         Request
         {
         "DealId":10132,
         "UserId":1
         }
         */
        let urlString = CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSaveReedm()
        let dataDict = self.dealDetailDict
        if let dealID = (dataDict as AnyObject).value(forKey: "Id") as? Int{
            let parameters = ["DealId":String(dealID),"UserId":CXAppConfig.sharedInstance.getUserID()]
            //{"DealId":"2","UserId":"2"}
            CXDataService.sharedInstance.postTheDataToServer(urlString: urlString, parameters: parameters, completion: { (responce) in
                CXLog.print(responce)
                self.getDealDataByID()
                self.view.makeToast(message: "Redeem Successfully")
            })
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

extension DealsDetailsViewController:KIImagePagerDelegate,KIImagePagerDataSource {
    func array(withImages pager: KIImagePager!) -> [Any]! {
        return self.coverPageImagesList as! [Any]!
        //return ["" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject]
    }
    //    }
    
    func contentMode(forImage image: UInt, in pager: KIImagePager!) -> UIViewContentMode {
        
        return .scaleAspectFill
    }
    
}

extension DealsDetailsViewController: ReviewSubMitDelegate{
    
    func didSubmitReview() {
        self.getDealDataByID()
    }
}



/*
extension DealsDetailsViewController: FloatRatingViewDelegate {
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
       // liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
     //   updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
}
*/
