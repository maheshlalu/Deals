//
//  DealsDetailsViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 05/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class DealsDetailsViewController: UIViewController {

    
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var offerBtn: UIButton!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: UIViewController?
    @IBOutlet weak var pagerView: KIImagePager!
    var coverPageImagesList: NSMutableArray!

    var dealId :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDealDataByID()
        CXLog.print(dealId)
        // Do any additional setup after loading the view.
    }
    
    
    
    func getDealDataByID(){
       // http://api.walk2deals.com/api/Deal/GetById/2
        let otpUrlString = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getDealByIDUrl() + "\(self.dealId!)"
        CXDataService.sharedInstance.getTheDataFromServer(urlString: otpUrlString, completion: { (responceDic) in
            CXLog.print(" deail deatil dic\(responceDic)")
            self.aboutButtonAction(UIButton())
            self.imageViewAimations(dealsDic: responceDic)
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageViewAimations(dealsDic:NSDictionary){
        
        // var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(timerCall()), userInfo: nil, repeats: true)
        
        self.coverPageImagesList = NSMutableArray()
        let attachements: NSArray = dealsDic.value(forKey: "ImageCDNUrls") as! NSArray
        
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

    
    @IBAction func reviewButtonAction(_ sender: UIButton) {

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let reviews : ReviewListViewController = (storyBoard.instantiateViewController(withIdentifier: "ReviewListViewController") as? ReviewListViewController)!
        reviews.view.translatesAutoresizingMaskIntoConstraints = false
        self.currentViewController = reviews
        self.cycleFromViewController(self.currentViewController!, toViewController: reviews)
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false

    }
    
    @IBAction func aboutButtonAction(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let reviews : AboutDeailViewController = (storyBoard.instantiateViewController(withIdentifier: "AboutDeailViewController") as? AboutDeailViewController)!
        reviews.view.translatesAutoresizingMaskIntoConstraints = false
        self.currentViewController = reviews
        self.cycleFromViewController(self.currentViewController!, toViewController: reviews)
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)

        
    }
    
    
    func cycleFromViewController(_ oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParentViewController: self)
        })
    }
    
    func addSubview(_ subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
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
        
        return ["" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject]
    }
    
    
    //    }
    
    func contentMode(forImage image: UInt, in pager: KIImagePager!) -> UIViewContentMode {
        
        return .scaleAspectFill
    }
    //    public func array(withImages pager: KIImagePager!) -> [Any]! {
    //        return ["" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject]
    //    }
    
    
    
    //    func array(withImages pager: KIImagePager!) -> [AnyObject]! {
    //        return self.coverPageImagesList as [AnyObject]
    //    }
    //    
}
