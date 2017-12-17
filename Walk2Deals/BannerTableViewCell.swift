//
//  BannerTableViewCell.swift
//  Walk2Deals
//
//  Created by Rama on 12/17/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import ImageSlideshow

class BannerTableViewCell: UITableViewCell {

    @IBOutlet weak var imageSlideView: ImageSlideshow!
    var sources:[AFURLSource] = [AFURLSource]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*
         DealId = 10137;
         DealImageUrl = "http://89c864a87c3ad18dae47-7bbeedb9edb88b42dee08f7ffab566a2.r82.cf5.rackcdn.com//W2D/Dev/Deal/10095.1513055389390";
         },
         */
    }
    
    func addTheBannerImage(imageList:NSArray){
        for dict in imageList {
            let dataDict = dict as? NSDictionary
            let imgUrlStr = dataDict?.object(forKey: "DealImageUrl") as! String
            CXLog.print(imgUrlStr)
            let fileUrl = Foundation.URL(string: imgUrlStr)
            self.sources.append(AFURLSource(url: fileUrl!,placeholder: UIImage(named: "sampleDeal")!))
        }
        self.setUpBannerSlider()
        
        /* let imgUrlStr = dic.object(forKey: "URL") as! String
         CXLog.print(imgUrlStr)
         let fileUrl = Foundation.URL(string: imgUrlStr)
         self.sources.append(AFURLSource(url: fileUrl!,placeholder: UIImage(named: "splash_logo")!))*/
    }
    //MARK: Banner Setup
    func setUpBannerSlider()
    {
        
        imageSlideView.backgroundColor = UIColor.white
        imageSlideView.slideshowInterval = 3
        imageSlideView.pageControlPosition = PageControlPosition.insideScrollView
       // imageSlideView.pageControl.currentPageIndicatorTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        imageSlideView.pageControl.pageIndicatorTintColor = UIColor.gray
        imageSlideView.contentScaleMode = UIViewContentMode.scaleAspectFill
        imageSlideView.clipsToBounds=true
        imageSlideView.setImageInputs(self.sources)
        CXDataService.sharedInstance.hideLoader()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
