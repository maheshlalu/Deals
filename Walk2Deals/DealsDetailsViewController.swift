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
    
    @IBOutlet weak var rattingLbl: UILabel!
    var dealDetailDict : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDealDataByID()
        
        
        //CXLog.print(dealId)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func setUpTabPager(){
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorColor(UIColor.white),
            .selectedMenuItemLabelColor(UIColor.white),
            .menuHeight(40),
            .scrollMenuBackgroundColor(UIColor.gray),
            .menuItemWidth(self.view.frame.size.width/2-16)
        ]
        let aboutDeal : AboutDeailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutDeailViewController") as! AboutDeailViewController
        aboutDeal.title = "About"
        aboutDeal.dealDetailDict = self.dealDetailDict
        let reviewsVc : ReviewListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewListViewController") as! ReviewListViewController
        reviewsVc.title = "Reviews"
        reviewsVc.dealDetailDict = self.dealDetailDict
        ///ReviewListViewController
        let pagerHeight = UIScreen.main.bounds.size.height - (self.pagerHeight.constant + self.writeReviewHeight.constant + 70)
        
        self.pageMenu = CAPSPageMenu(viewControllers: [aboutDeal,reviewsVc], frame: CGRect(x: 0, y: self.pagerHeight.constant+1+50, width: self.view.frame.width, height: pagerHeight-50), pageMenuOptions: parameters)
        self.view.addSubview((self.pageMenu?.view)!)
    }
    
    
    func getDealDataByID(){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
       // http://api.walk2deals.com/api/Deal/GetById/2
        let otpUrlString = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getDealByIDUrl() + "\(self.dealId!)"
        CXDataService.sharedInstance.getTheDataFromServer(urlString: otpUrlString, completion: { (responceDic) in
            CXLog.print(" deail deatil dic\(responceDic)")
            self.dealDetailDict = responceDic
            CXDataService.sharedInstance.hideLoader()
            self.populatedTheData()
            })
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
        }
    }

   
    @IBAction func writeReviewBtnAction(_ sender: UIButton) {
        let storyBaord = UIStoryboard(name: "Main", bundle: nil)
        let writeReviewVc = storyBaord.instantiateViewController(withIdentifier: "WriteReviewViewController") as? WriteReviewViewController
        writeReviewVc?.dealID = self.dealId
        writeReviewVc?.delegate = self
        self.navigationController?.pushViewController(writeReviewVc!, animated: true)
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
